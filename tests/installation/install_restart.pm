# Copyright (C) 2018 SUSE LLC
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, see <http://www.gnu.org/licenses/>.

use base 'basetest';
use strict;
use testapi;

sub run {

    # Install is complete, reboot
    assert_and_click "rebootnow", 'left', 300;

    # Please remove the installation medium, then press ENTER:
    if (check_screen('medium', 10)) {
        assert_screen 'medium';
        send_key 'ret';
    }
    else {
        record_soft_failure "Nothing happens";
        # Workaround
        send_key "ctrl-alt-f3";
        send_key "ctrl-alt-delete";
        if (check_screen('cannotreboot', 60)) {
            record_soft_failure "systemd cannot umount device";
        }
        power('reset');
        assert_screen [qw(bios gdm_login)], 120;
    }


    sleep 10;

    if (check_screen('medium', 10)) {
        record_soft_failure "Nothing happens";
        # Workaround
        send_key "ctrl-alt-f3";
        send_key "ctrl-alt-delete";
        if (check_screen('cannotreboot', 60)) {
            record_soft_failure "systemd cannot umount device";
        }
        power('reset');
        assert_screen [qw(bios gdm_login)], 120;
    }
    else {
        assert_screen [qw(bios gdm_login)], 120;
    }
}

sub test_flags {
    # 'fatal'          - abort whole test suite if this fails (and set overall state 'failed')
    # 'ignore_failure' - if this module fails, it will not affect the overall result at all
    # 'milestone'      - after this test succeeds, update 'lastgood'
    # 'norollback'     - don't roll back to 'lastgood' snapshot if this fails
    return { fatal => 1 };
}

1;

# vim: set sw=4 et:
