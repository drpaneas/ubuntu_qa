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
    # Vars
    #set_var('PUBLISH_HDD_1', 'ubuntu.qcow2');
    #set_var('QEMU_COMPRESS_QCOW2', 1);

    # Tests
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
    # Vars
    #set_var('BOOT_HDD_IMAGE', 1);
    #set_var('HDD_1', 'ubuntu.qcow2');
    #set_var('START_AFTER_TEST', 'desktop_installation');

    # Tests
    loadtest 'gnome/gdm';
    loadtest 'gnome/shutdown';
}


1;
# vim: set sw=4 et:
