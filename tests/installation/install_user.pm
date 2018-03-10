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

    assert_screen 'install_user';

    # Your name
    assert_and_click 'your_name';
    type_string 'Panos Georgiadis';

    # Your computer's name
    assert_screen 'computer_name';

    # Pick a username
    assert_screen 'install_username';

    # Choose a password
    assert_and_click 'install_password';
    type_string '123456789';

    # Confirm your password
    assert_and_click 'install_confirm';
    type_string '123456789';

    # Require my password to login
    assert_screen 'require_passwd_login';

    # Click continue btn
    assert_and_click 'continue';

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
