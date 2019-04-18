use Kaomojic::Strict;

use Test::Spec;

describe 'ベース辞書に対して' => sub {
    context 'kaomoji.txt において' => sub {
        it '重複が発生していない' => sub {
            ok 1;
        };
    };
};

runtests unless caller;