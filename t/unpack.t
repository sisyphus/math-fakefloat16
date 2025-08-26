use strict;
use warnings;
use Math::FakeFloat16 qw(:all);

use Test::More;
cmp_ok(unpack_f16_hex($Math::FakeFloat16::f16_DENORM_MIN), 'eq', '0001', "DENORM_MIN unpacks correctly");
cmp_ok(unpack_f16_hex($Math::FakeFloat16::f16_DENORM_MAX), 'eq', '007F', "DENORM_MAX unpacks correctly");
cmp_ok(unpack_f16_hex($Math::FakeFloat16::f16_NORM_MIN),   'eq', '0080', "NORM_MIN unpacks correctly");
cmp_ok(unpack_f16_hex($Math::FakeFloat16::f16_NORM_MAX),   'eq', '7F7F', "NORM_MAX unpacks correctly");
cmp_ok(unpack_f16_hex(sqrt(Math::FakeFloat16->new(2))),     'eq', '3FB5', "sqrt 2 unpacks correctly");
cmp_ok(unpack_f16_hex(Math::FakeFloat16->new('5e-41')),     'eq', '0001', "'5e-41' unpacks correctly");
cmp_ok(unpack_f16_hex(Math::FakeFloat16->new(Math::MPFR->new('5e-41'))), 'eq', '0001', "MPFR('5e-41') unpacks correctly");

cmp_ok(unpack_f16_hex(-$Math::FakeFloat16::f16_DENORM_MIN), 'eq', '8001', "-DENORM_MIN unpacks correctly");
cmp_ok(unpack_f16_hex(-$Math::FakeFloat16::f16_DENORM_MAX), 'eq', '807F', "-DENORM_MAX unpacks correctly");
cmp_ok(unpack_f16_hex(-$Math::FakeFloat16::f16_NORM_MIN),   'eq', '8080', "-NORM_MIN unpacks correctly");
cmp_ok(unpack_f16_hex(-$Math::FakeFloat16::f16_NORM_MAX),   'eq', 'FF7F', "-NORM_MAX unpacks correctly");
cmp_ok(unpack_f16_hex(-(sqrt(Math::FakeFloat16->new(2)))),   'eq', 'BFB5', "-(sqrt 2) unpacks correctly");
cmp_ok(unpack_f16_hex(Math::FakeFloat16->new('-5e-41')),     'eq', '8001', "'-5e-41' unpacks correctly");
cmp_ok(unpack_f16_hex(Math::FakeFloat16->new(Math::MPFR->new('-5e-41'))), 'eq', '8001', "MPFR('5e-41') unpacks correctly");

done_testing();
