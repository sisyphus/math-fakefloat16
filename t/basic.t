use strict;
use warnings;

use Math::FakeFloat16 qw(:all);

use Test::More;

cmp_ok($Math::FakeFloat16::VERSION, '==', 0.01, "We have Math-FakeFloat16-0.01");


done_testing();
