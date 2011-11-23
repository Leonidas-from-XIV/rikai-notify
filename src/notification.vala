/*
    Copyright (C) 2011  Marek Kubica

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

using Notify;

class Rikai.Notification : GLib.Object {
	Notify.Notification? ntfy;

	public void display(string title, string body) {
		stdout.printf("Title: '%s' Body: '%s'\n", title, body);
		if (ntfy == null) {
			Notify.init("rikai-notify");
			ntfy = new Notify.Notification(title, body, null);
			ntfy.set_timeout(5500);
			ntfy.set_urgency(Notify.Urgency.CRITICAL);
		} else {
			ntfy.update(title, body, null);
		}
		try {
			ntfy.show();
		} catch (Error e) {
			stderr.printf("Showing notification failed, error %s",
				e.message);
		}
	}
}
