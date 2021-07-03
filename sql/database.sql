CREATE TABLE IF NOT EXISTS money(
	player TEXT PRIMARY KEY NOT NULL CHECK (length(trim(player)) > 0),
	amount INTEGER NOT NULL CHECK (amount >= 0)
);
CREATE TABLE IF NOT EXISTS transactions(
	id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
	date INTEGER NOT NULL,
	player1 TEXT NOT NULL DEFAULT 'unknown' CHECK (length(trim(player1)) > 0),
	player2 TEXT NOT NULL DEFAULT 'unknown' CHECK (length(trim(player2)) > 0),
	amount INTEGER NOT NULL CHECK (amount > 0),
	CHECK (player1 != player2),
	FOREIGN KEY(player1) REFERENCES money(player)
		ON DELETE SET DEFAULT
		ON UPDATE CASCADE
	FOREIGN KEY(player2) REFERENCES money(player)
		ON DELETE SET DEFAULT
		ON UPDATE CASCADE
);