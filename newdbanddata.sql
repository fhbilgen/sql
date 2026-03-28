IF DB_ID(N'testdb') IS NULL
BEGIN
	CREATE DATABASE testdb;
END;
GO

USE testdb;
GO

IF OBJECT_ID(N'dbo.cities', N'U') IS NULL
BEGIN
	CREATE TABLE dbo.cities (
		code INT NOT NULL,
		name VARCHAR(30) NOT NULL,
		callcode INT NOT NULL
	);
END;
GO

INSERT INTO dbo.cities (code, name, callcode)
SELECT v.code, v.name, v.callcode
FROM (VALUES
	(1, 'adana', 322),
	(2, 'adiyaman', 416),
	(3, 'afyonkarahisar', 272),
	(4, 'agri', 472),
	(5, 'amasya', 358),
	(6, 'ankara', 312),
	(7, 'antalya', 242),
	(8, 'artvin', 466),
	(9, 'aydin', 256),
	(10, 'balikesir', 266),
	(11, 'bilecik', 228),
	(12, 'bingol', 426),
	(13, 'bitlis', 434),
	(14, 'bolu', 374),
	(15, 'burdur', 248),
	(16, 'bursa', 224),
	(17, 'canakkale', 286),
	(18, 'cankiri', 376),
	(19, 'corum', 364),
	(20, 'denizli', 258),
	(21, 'diyarbakir', 412),
	(22, 'edirne', 284),
	(23, 'elazig', 424),
	(24, 'erzincan', 446),
	(25, 'erzurum', 442),
	(26, 'eskisehir', 222),
	(27, 'gaziantep', 342),
	(28, 'giresun', 454),
	(29, 'gumushane', 456),
	(30, 'hakkari', 438),
	(31, 'hatay', 326),
	(32, 'isparta', 246),
	(33, 'mersin', 324),
	(34, 'istanbul', 212),
	(35, 'izmir', 232),
	(36, 'kars', 474),
	(37, 'kastamonu', 366),
	(38, 'kayseri', 352),
	(39, 'kirklareli', 288),
	(40, 'kirsehir', 386),
	(41, 'kocaeli', 262),
	(42, 'konya', 332),
	(43, 'kutahya', 274),
	(44, 'malatya', 422),
	(45, 'manisa', 236),
	(46, 'kahramanmaras', 344),
	(47, 'mardin', 482),
	(48, 'mugla', 252),
	(49, 'mus', 436),
	(50, 'nevsehir', 384),
	(51, 'nigde', 388),
	(52, 'ordu', 452),
	(53, 'rize', 464),
	(54, 'sakarya', 264),
	(55, 'samsun', 362),
	(56, 'siirt', 484),
	(57, 'sinop', 368),
	(58, 'sivas', 346),
	(59, 'tekirdag', 282),
	(60, 'tokat', 356),
	(61, 'trabzon', 462),
	(62, 'tunceli', 428),
	(63, 'sanliurfa', 414),
	(64, 'usak', 276),
	(65, 'van', 432),
	(66, 'yozgat', 354),
	(67, 'zonguldak', 372),
	(68, 'aksaray', 382),
	(69, 'bayburt', 458),
	(70, 'karaman', 338),
	(71, 'kirikkale', 318),
	(72, 'batman', 488),
	(73, 'sirnak', 486),
	(74, 'bartin', 378),
	(75, 'ardahan', 478),
	(76, 'igdir', 476),
	(77, 'yalova', 226),
	(78, 'karabuk', 370),
	(79, 'kilis', 348),
	(80, 'osmaniye', 328),
	(81, 'duzce', 380)
) AS v(code, name, callcode)
WHERE NOT EXISTS (
	SELECT 1
	FROM dbo.cities AS c
	WHERE c.code = v.code
);
GO
