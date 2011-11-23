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

using Gtk;

class Rikai.Main : GLib.Object {
	public static int main(string[] args) {
		Gtk.init(ref args);
		try {
			var dictPath = Dictionary.locate_dictionary();
			var notification = new Notification();
			var dictionary = new Dictionary(dictPath);
			var clipboard = new Clipboard(dictionary, notification.display);

			Gtk.main();
		} catch (LocationError e) {
			stderr.printf("Error: %s\n", e.message);
			return 1;
		} catch (DatabaseError e) {
			stderr.printf(
				"Database cannot be opened. Make sure it is not corrupted\n");
		}

		return 0;
	}
}
