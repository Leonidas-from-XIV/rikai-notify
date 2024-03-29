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

class Rikai.Clipboard : GLib.Object {
	public delegate void NotificationCallback(string summary, string body);
	public Clipboard(Dictionary dict, NotificationCallback callback) {
		var clip = Gtk.Clipboard.get(Gdk.Atom.intern("PRIMARY", false));
		clip.owner_change.connect(() => {
			string text = clip.wait_for_text();
			if (text != null) {
				if (
					(text.get_char() >= 0x4E00 && text.get_char() <= 0x9FAF) ||
					(text.get_char() >= 0x30A0 && text.get_char() <= 0x30FF) ||
					(text.get_char() >= 0x3040 && text.get_char() <= 0x309F)) {
					try {
						var translation = dict.look_up(text);
						callback(text, translation);
					} catch (LookupError e) {
						if (e is LookupError.DATABASE_FAILURE) {
							stderr.printf("%s\n", e.message);
						} else {
							// well, we don't have to do anything
							stderr.printf("Meaning of phrase '%s' unknown\n",
								text);
						}
					}
				}
			}
		});
	}
}
