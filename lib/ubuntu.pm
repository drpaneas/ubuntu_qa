# SUSE's openQA tests
#
# Copyright © 2017 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

package ubuntu;

use base Exporter;
use Exporter;
use strict;
use warnings;
use testapi;

our @EXPORT = qw(gnome_shutdown);

# Process reboot with an option to trigger it
sub gnome_shutdown {
    # Click on the right up corner
    assert_and_click 'gnome_out';

    # Click on the Turn-Off icon
    assert_and_click 'gnome_shutdown';

    # Select the Power-Off
    assert_and_click 'gnome_shutdown_ok';

    # Last messages that appear
    if (check_var('INSTALL_TYPE', 'try')) {
        assert_screen 'medium';
        send_key 'ret';
    }

    # Make sure the VM it's dead
    assert_shutdown(300);

}

1;
