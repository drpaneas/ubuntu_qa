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

# LiveDVD try out environment
if (check_var('INSTALL_TYPE', 'try')) {
    loadtest 'installation/boot';
    loadtest 'installation/welcome';
    loadtest 'installation/try_ubuntu';
    loadtest 'gnome/shutdown';
}

# Graphical Installation from the DVD
if (check_var('INSTALL_TYPE', 'install')) {
    loadtest 'installation/boot';
    loadtest 'installation/welcome';
    loadtest 'installation/preparing';
    loadtest 'installation/install_type';
    loadtest 'installation/install_location';
    loadtest 'installation/install_keyboard';
    loadtest 'installation/install_user';
    loadtest 'installation/install_wait';
    loadtest 'installation/install_restart';
    loadtest 'gnome/gdm';
    loadtest 'gnome/shutdown';
}

if (check_var('TEST_TYPE', 'GUI')) {
    loadtest 'gnome/gdm';
    loadtest 'gnome/shutdown';
}


1;
# vim: set sw=4 et:
