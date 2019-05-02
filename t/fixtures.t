use Kaomojic::Strict;

# https://metacpan.org/pod/Test::More#utf8-/-%22Wide-character-in-print%22
use open ':std', ':encoding(utf8)';

use Encode qw/encode_utf8/;
use List::MoreUtils qw/duplicates indexes/;
use String::CamelCase qw/camelize/;
use Test::Spec;

use Kaomojic::Fixtures::Kaomojic;

describe 'Fixture について' => sub {
    context '各 fixture において' => sub {
        my @fixtures = qw/kaomojic/;

        for my $fixture (@fixtures) {
            context "$fixture.yml において" => sub {
                my (@entries);

                before all => sub {
                    my $cls = "Kaomojic::Fixtures::" . camelize($fixture);
                    @entries = map { $_->[1] } @{$cls->load};
                };

                it 'エントリーに重複が発生していない' => sub {
                    my @duplicates = duplicates(@entries);
                    is @duplicates, 0;

                    # if duplicates is greater than or equals to 1, print line numbers.
                    if (scalar(@duplicates) != 0) {
                        foreach my $entry (@duplicates) {
                            my @indexes = indexes { $_ eq $entry} @entries;
                            my $message = join(', ', splice(@indexes, 1));
                            # ファイル入力からとったから?
                            diag("Duplicate entry \"$entry\" in line $message.");
                        }
                    }
                };
            };
        }
    };
};

runtests unless caller;