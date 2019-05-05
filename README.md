# Kaomojic

Kaomoji Dictionary for IMEs


## Contribution

### Add a new kaomoji

1. Fork this repository.
1. Add your kaomoji to `fixtures/kaomojic.csv`.
1. Format fixture; Run this command `./bin/runner.sh OrderFixture Kaomojic`.
1. Commit your changes and push to GitHub.
1. Submit a new pull request.


### Add a new generator

1. Fork this repository.
1. Create a generator file in `lib/Kaomojic/Tasks/Generators` such as `Atok.pm`.
1. Run command `./bin/runner.sh Generators::Atok Kaomojic ./dist/atok` and load it in your IME.
1. Add a generator job to `.circleci/config.yml`.
1. Commit your changes and push to GitHub.
1. Submit a new pull request.

