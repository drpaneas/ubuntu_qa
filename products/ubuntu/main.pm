use strict;
use warnings;
use testapi qw(check_var get_var get_required_var set_var);
use needle;
use File::Basename;

# It required openSUSE libraries to use utils and main_common
BEGIN {
    unshift @INC, dirname(__FILE__) . '/../../lib';
}
use utils;
use main_common;

init_main();

# Tests
loadtest 'installation/boot';
loadtest 'installation/welcome';

# Select between 'Try' or 'Installation'
loadtest 'installation/preparing' if check_var('INSTALL_TYPE', 'install');
loadtest 'installation/install_type' if check_var('INSTALL_TYPE', 'install');
loadtest 'installation/install_time' if check_var('INSTALL_TYPE', 'install');
loadtest 'installation/try_ubuntu' if check_var('INSTALL_TYPE', 'try');

1;
# vim: set sw=4 et:
