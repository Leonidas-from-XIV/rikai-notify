using Sqlite;

class JMDict.Dictionary : GLib.Object {
	private Database db;

	public Dictionary(string path) {
		int rc;

		rc = Database.open(path, out db);
	}

	public static int main(string[] args) {
		stdout.printf("Hello world\n");
		var dictionary = new Dictionary("/usr/share/tagainijisho/jmdict-en.db");
		return 0;
	}
}
