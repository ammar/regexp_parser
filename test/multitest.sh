# Poor man's multiruby, a wrapper bash function/script around rvm. This is
# used to run all the tests through all the supported versions of ruby.
#
# Requires that all the rubies listed below are installed via rvm. rvm gets
# sourced by the function.
#
# Usage: ./test/multitest.sh

multitest() {
  versions=('1.8.6' '1.8.7' '1.9.1' '1.9.2')

  source $HOME/.rvm/scripts/rvm

  echo "Running tests for ${#versions[@]} ruby versions"
  echo "------------------------------------------------------------"
  for version in ${versions[@]}
  do
    rvm ${version}
    echo `ruby --version`
    rake > test/run/${version}.run 2> test/run/${version}.run

    tail -n 3 test/run/${version}.run |
      egrep "[[:digit:]]+ tests, [[:digit:]]+ assertions"

    echo "------------------------------------------------------------"
  done
}

multitest
