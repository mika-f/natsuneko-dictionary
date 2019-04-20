use Kaomojic::Strict;

use String::CamelCase qw/camelize/;
use Test::Spec;

use Kaomojic::Fixtures::Kaomojic;

describe 'Fixture について' => sub {
    my ($fixture, $cls);
    
    shared_examples_for 'FixtureCheck' => sub {
        my ($yaml);

        before all => sub {
            $yaml = $cls->load;
        };

        it 'name エントリーが存在している' => sub {
            isnt $yaml->{name}, undef;
        };

        it 'エントリーに重複が発生していない' => sub {
            
        };
    };

    context '各 fixture において' => sub {
        my @fixtures = qw/kaomojic/;

        for my $fixture (@fixtures) {
            context "$fixture.yml において" => sub {
                before all => sub {
                    $cls = "Kaomojic::Fixtures::" . camelize($fixture);
                };

                it_should_behave_like 'FixtureCheck';
            }
        }
    };
};

runtests unless caller;