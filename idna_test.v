module idna

fn test_rfc3492() {
	//
	// 7.1 Sample strings
	//

	// (A) Arabic (Egyptian):
	assert to_unicode('xn--egbpdaj6bu4bxfgehfvwxn') == 'ليهمابتكلموشعربي؟'
	assert to_ascii('ليهمابتكلموشعربي؟') == 'xn--egbpdaj6bu4bxfgehfvwxn'

	// (B) Chinese (simplified):
	assert to_unicode('xn--ihqwcrb4cv8a8dqg056pqjye') == '他们为什么不说中文'
	assert to_ascii('他们为什么不说中文') == 'xn--ihqwcrb4cv8a8dqg056pqjye'

	// (C) Chinese (traditional):
	assert to_unicode('xn--ihqwctvzc91f659drss3x8bo0yb') == '他們爲什麽不說中文'
	assert to_ascii('他們爲什麽不說中文') == 'xn--ihqwctvzc91f659drss3x8bo0yb'

	// (D) Czech: Pro<ccaron>prost<ecaron>nemluv<iacute><ccaron>esky
	assert to_unicode('xn--Proprostnemluvesky-uyb24dma41a') == 'pročprostěnemluvíčesky'
	assert to_ascii('pročprostěnemluvíčesky') == 'xn--proprostnemluvesky-uyb24dma41a'

	// (E) Hebrew:
	assert to_unicode('xn--4dbcagdahymbxekheh6e0a7fei0b') == 'למההםפשוטלאמדבריםעברית'
	assert to_ascii('למההםפשוטלאמדבריםעברית') == 'xn--4dbcagdahymbxekheh6e0a7fei0b'

	// (F) Hindi (Devanagari):
	assert to_unicode('xn--i1baa7eci9glrd9b2ae1bj0hfcgg6iyaf8o0a1dig0cd') == 'यहलोगहिन्दीक्योंनहींबोलसकतेहैं'
	assert to_ascii('यहलोगहिन्दीक्योंनहींबोलसकतेहैं') == 'xn--i1baa7eci9glrd9b2ae1bj0hfcgg6iyaf8o0a1dig0cd'

	// (G) Japanese (kanji and hiragana):
	assert to_unicode('xn--n8jok5ay5dzabd5bym9f0cm5685rrjetr6pdxa') == 'なぜみんな日本語を話してくれないのか'
	assert to_ascii('なぜみんな日本語を話してくれないのか') == 'xn--n8jok5ay5dzabd5bym9f0cm5685rrjetr6pdxa'

	// (H) Korean (Hangul syllables):
	assert to_unicode('xn--989aomsvi5e83db1d2a355cv1e0vak1dwrv93d5xbh15a0dt30a5jpsd879ccm6fea98c') == '세계의모든사람들이한국어를이해한다면얼마나좋을까'
	assert to_ascii('세계의모든사람들이한국어를이해한다면얼마나좋을까') == 'xn--989aomsvi5e83db1d2a355cv1e0vak1dwrv93d5xbh15a0dt30a5jpsd879ccm6fea98c'

	// (I) Russian (Cyrillic):
	assert to_unicode('xn--b1abfaaepdrnnbgefbaDotcwatmq2g4l') == 'почемужеонинеговорятпорусски'
	assert to_ascii('почемужеонинеговорятпорусски') == 'xn--b1abfaaepdrnnbgefbadotcwatmq2g4l'

	// (J) Spanish: Porqu<eacute>nopuedensimplementehablarenEspa<ntilde>ol
	assert to_unicode('xn--PorqunopuedensimplementehablarenEspaol-fmd56a') == 'porquénopuedensimplementehablarenespañol'
	assert to_ascii('porquénopuedensimplementehablarenespañol') == 'xn--porqunopuedensimplementehablarenespaol-fmd56a'

	// (K) Vietnamese:
	assert to_unicode('xn--TisaohkhngthchnitingVit-kjcr8268qyxafd2f1b9g') == 'tạisaohọkhôngthểchỉnóitiếngviệt'
	assert to_ascii('tạisaohọkhôngthểchỉnóitiếngviệt') == 'xn--tisaohkhngthchnitingvit-kjcr8268qyxafd2f1b9g'

	// (L) 3<nen>B<gumi><kinpachi><sensei>
	assert to_unicode('xn--3B-ww4c5e180e575a65lsy2b') == '3年b組金八先生'
	assert to_ascii('3年b組金八先生') == 'xn--3b-ww4c5e180e575a65lsy2b'

	// (M) <amuro><namie>-with-SUPER-MONKEYS
	assert to_unicode('xn---with-SUPER-MONKEYS-pc58ag80a8qai00g7n9n') == '安室奈美恵-with-super-monkeys'
	assert to_ascii('安室奈美恵-with-super-monkeys') == 'xn---with-super-monkeys-pc58ag80a8qai00g7n9n'

	// (N) Hello-Another-Way-<sorezore><no><basho>
	assert to_unicode('xn--Hello-Another-Way--fc4qua05auwb3674vfr0b') == 'hello-another-way-それぞれの場所'
	assert to_ascii('hello-another-way-それぞれの場所') == 'xn--hello-another-way--fc4qua05auwb3674vfr0b'

	// (O) <hitotsu><yane><no><shita>2
	assert to_unicode('xn--2-u9tlzr9756bt3uc0v') == 'ひとつ屋根の下2'
	assert to_ascii('ひとつ屋根の下2') == 'xn--2-u9tlzr9756bt3uc0v'

	// (P) Maji<de>Koi<suru>5<byou><mae>
	assert to_unicode('xn--MajiKoi5-783gue6qz075azm5e') == 'majiでkoiする5秒前'
	assert to_ascii('majiでkoiする5秒前') == 'xn--majikoi5-783gue6qz075azm5e'

	// (Q) <pafii>de<runba>
	assert to_unicode('xn--de-jg4avhby1noc0d') == 'パフィーdeルンバ'
	assert to_ascii('パフィーdeルンバ') == 'xn--de-jg4avhby1noc0d'

	// (R) <sono><supiido><de>
	assert to_unicode('xn--d9juau41awczczp') == 'そのスピードで'
	assert to_ascii('そのスピードで') == 'xn--d9juau41awczczp'

	// (S) -> $1.00 <-
	//assert to_unicode('xn--') == ''
	//assert decode('\u002D\u003E\u0020\u0024\u0031\u002E\u0030\u0030\u0020\u003C\u002D') == '-> $1.00 <-'
}

fn idna2008() {
	assert to_unicode('xn--dmin-moa0i.example') == 'dömäin.example'
	assert to_ascii('dömäin.example') == 'xn--dmin-moa0i.example'
}

fn test_my_own_stuff() {
	//assert to_unicode('xn--caf-dma.com') == 'café.com'  // @TODO: Test fails
	assert to_ascii('café.com') == 'xn--caf-dma.com'

	//assert to_unicode('xn--rolx-nu5a.com') == 'rolẹx.com'  // @TODO: Test fails
	assert to_ascii('rolẹx.com') == 'xn--rolx-nu5a.com'

	//assert to_unicode('xn--lid-xbb.com') == 'lidǀ.com'  // @TODO: Test fails
	assert to_ascii('lidǀ.com') == 'xn--lid-xbb.com'

	//assert to_unicode('xn--googe-95a.com') == 'googĺe.com'  // @TODO: Test fails
	assert to_ascii('googĺe.com') == 'xn--googe-95a.com'

	//assert to_unicode('xn--ibeia-lp1b.com') == 'ibeṛia.com'  // @TODO: Test fails
	assert to_ascii('ibeṛia.com') == 'xn--ibeia-lp1b.com'
}
