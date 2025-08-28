use strict;
use warnings;
use Math::FakeFloat16 qw(:all);

use Test::More;
cmp_ok(unpack_f16_hex($Math::FakeFloat16::f16_DENORM_MIN), 'eq', '0001', "DENORM_MIN unpacks correctly");
cmp_ok(unpack_f16_hex($Math::FakeFloat16::f16_DENORM_MAX), 'eq', '03FF', "DENORM_MAX unpacks correctly");
cmp_ok(unpack_f16_hex($Math::FakeFloat16::f16_NORM_MIN),   'eq', '0400', "NORM_MIN unpacks correctly");
cmp_ok(unpack_f16_hex($Math::FakeFloat16::f16_NORM_MAX),   'eq', '7BFF', "NORM_MAX unpacks correctly");
cmp_ok(unpack_f16_hex(sqrt(Math::FakeFloat16->new(2))),     'eq', '3DA8', "sqrt 2 unpacks correctly");
cmp_ok(unpack_f16_hex(Math::FakeFloat16->new('5e-41')),     'eq', '0000', "'5e-41' unpacks correctly");
cmp_ok(unpack_f16_hex(Math::FakeFloat16->new(Math::MPFR->new('5e-41'))), 'eq', '0000', "MPFR('5e-41') unpacks correctly");

cmp_ok(unpack_f16_hex(-$Math::FakeFloat16::f16_DENORM_MIN), 'eq', '8001', "-DENORM_MIN unpacks correctly");
cmp_ok(unpack_f16_hex(-$Math::FakeFloat16::f16_DENORM_MAX), 'eq', '83FF', "-DENORM_MAX unpacks correctly");
cmp_ok(unpack_f16_hex(-$Math::FakeFloat16::f16_NORM_MIN),   'eq', '8400', "-NORM_MIN unpacks correctly");
cmp_ok(unpack_f16_hex(-$Math::FakeFloat16::f16_NORM_MAX),   'eq', 'FBFF', "-NORM_MAX unpacks correctly");
cmp_ok(unpack_f16_hex(-(sqrt(Math::FakeFloat16->new(2)))),   'eq', 'BDA8', "-(sqrt 2) unpacks correctly");
cmp_ok(unpack_f16_hex(Math::FakeFloat16->new('-5e-41')),     'eq', '8000', "'-5e-41' unpacks correctly");
cmp_ok(unpack_f16_hex(Math::FakeFloat16->new(Math::MPFR->new('-5e-41'))), 'eq', '8000', "MPFR('5e-41') unpacks correctly");

my $have_Math_Float16 = 0;

eval { require Math::Float16;};
$have_Math_Float16 = 1 unless $@;

if($have_Math_Float16) {

  eval { my $s = Math::Float16::unpack_f16_hex(Math::FakeFloat16->new(42));};
  like($@, qr/^Math::Float16::unpack_f16_hex/, "Math::Float16 unpack_f16_hex() is picky");

  eval { my $s = Math::FakeFloat16::unpack_f16_hex(Math::Float16->new(42));};
  like($@, qr/^Math::FakeFloat16::unpack_f16_hex/, "Math::FakeFloat16 unpack_f16_hex() is picky");

  my $minf = Math::MPFR->new('inf');
  my $finf = Math::Float16->new($minf);
  my $fake_finf = Math::FakeFloat16->new('inf');

  my $pinfstr = Math::Float16::unpack_f16_hex($finf);
  my $ninfstr = Math::Float16::unpack_f16_hex(-$finf);

  cmp_ok($pinfstr, 'eq', '7C00', "+Inf is 7C00");
  cmp_ok($ninfstr, 'eq', 'FC00', "-Inf is FC00");

  cmp_ok($pinfstr, 'eq', unpack_f16_hex(Math::FakeFloat16->new($minf)), "fake unpack +Inf ok");
  cmp_ok($ninfstr, 'eq', unpack_f16_hex(Math::FakeFloat16->new(-$minf)), "fake unpack -Inf ok");
  cmp_ok(unpack_f16_hex(Math::FakeFloat16->new()), 'eq', 'FE00', "fake unpack NaN is ok");
  cmp_ok(unpack_f16_hex(Math::FakeFloat16->new('0')), 'eq', '0000', "fake unpack 0 is ok");
  cmp_ok(unpack_f16_hex(Math::FakeFloat16->new('-0')), 'eq', '8000', "fake unpack -0 is ok");

  my $x = Math::FakeFloat16->new($Math::FakeFloat16::f16_DENORM_MAX);
  cmp_ok(unpack_f16_hex($x), 'eq', Math::Float16::unpack_f16_hex(Math::Float16->new("$x")), "DENORM_MAX: fake and real agree");
  cmp_ok(unpack_f16_hex(-$x), 'eq', Math::Float16::unpack_f16_hex(Math::Float16->new("-$x")), "-DENORM_MAX: fake and real agree");

  $x = Math::FakeFloat16->new($Math::FakeFloat16::f16_DENORM_MIN);
  cmp_ok(unpack_f16_hex($x), 'eq', Math::Float16::unpack_f16_hex(Math::Float16->new("$x")), "DENORM_MIN: fake and real agree");
  cmp_ok(unpack_f16_hex(-$x), 'eq', Math::Float16::unpack_f16_hex(Math::Float16->new("-$x")), "-DENORM_MIN: fake and real agree");

  for(1 .. 1022) { ## DO NOT ALTER
    $x += Math::FakeFloat16->new($Math::FakeFloat16::f16_DENORM_MIN);
    my $real_pos = Math::Float16::unpack_f16_hex(Math::Float16->new("$x"));
    my $real_neg = Math::Float16::unpack_f16_hex(Math::Float16->new("-$x"));
    cmp_ok(unpack_f16_hex($x),  'eq', $real_pos, "$real_pos: fake and real agree");
    cmp_ok(unpack_f16_hex(-$x), 'eq', $real_neg, "$real_neg: fake and real agree");
  }

  f16_nextabove($x);

  cmp_ok($x, '==', $Math::FakeFloat16::f16_NORM_MIN, "value is at +NORM_MIN");

  for(1..1025) { ## DO NOT ALTER
    my $real_pos = Math::Float16::unpack_f16_hex(Math::Float16->new("$x"));
    my $real_neg = Math::Float16::unpack_f16_hex(Math::Float16->new("-$x"));
    cmp_ok(unpack_f16_hex($x),  'eq', $real_pos, "$x: $real_pos: fake and real agree");
    cmp_ok(unpack_f16_hex(-$x), 'eq', $real_neg, "-$x: $real_neg: fake and real agree");
    f16_nextabove($x);
  }

  cmp_ok($x, '==', '1.2219e-4', "value is at 1.2219e-4");

  for(1..29696) {
    my $real_pos = Math::Float16::unpack_f16_hex(Math::Float16->new("$x"));
    my $real_neg = Math::Float16::unpack_f16_hex(Math::Float16->new("-$x"));
    cmp_ok(unpack_f16_hex($x),  'eq', $real_pos, "$x: $real_pos: fake and real agree");
    cmp_ok(unpack_f16_hex(-$x), 'eq', $real_neg, "-$x: $real_neg: fake and real agree");
    f16_nextabove($x);
  }
}

done_testing();

__END__
Math::Float16::unpack_f16_hex
