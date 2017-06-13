﻿Функция ЕстьОтрицательныеОстатки(СсылкаНаДокумент, Организация, СтруктурнаяЕдиница) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Организация", УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Организация));
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", СтруктурнаяЕдиница);
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ЗапасыНаСкладахОстатки.Номенклатура,
		|	ЗапасыНаСкладахОстатки.КоличествоОстаток
		|ИЗ
		|	РегистрНакопления.ЗапасыНаСкладах.Остатки(
		|			,
		|			Организация = &Организация
		|				И СтруктурнаяЕдиница = &СтруктурнаяЕдиница) КАК ЗапасыНаСкладахОстатки
		|ГДЕ
		|	ЗапасыНаСкладахОстатки.КоличествоОстаток < 0
		|;";
		
	Если НачалоМесяца(СсылкаНаДокумент.Дата) < НачалоМесяца(ТекущаяДатаСеанса()) Тогда
		Запрос.Текст = Запрос.Текст + "
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 1
		|	ЗапасыНаСкладахОстатки.Номенклатура,
		|	ЗапасыНаСкладахОстатки.КоличествоОстаток
		|ИЗ
		|	РегистрНакопления.ЗапасыНаСкладах.Остатки(
		|			&ГраницаДокументаВключая,
		|			Организация = &Организация
		|				И СтруктурнаяЕдиница = &СтруктурнаяЕдиница) КАК ЗапасыНаСкладахОстатки
		|ГДЕ
		|	ЗапасыНаСкладахОстатки.КоличествоОстаток < 0";
		
		Запрос.УстановитьПараметр("ГраницаДокументаВключая", Новый Граница(КонецМесяца(СсылкаНаДокумент.Дата), ВидГраницы.Включая));
		МРезультатов = Запрос.ВыполнитьПакет();
		
		Если НЕ МРезультатов[0].Пустой() И НЕ МРезультатов[1].Пустой() Тогда
			Возврат СтрЗаменить(НСтр("ru = 'Есть остатки < 0 на %КонецМесяца% и на текущую дату'"), "%КонецМесяца%", Формат(КонецМесяца(СсылкаНаДокумент.Дата), "ДЛФ=D"));
		ИначеЕсли НЕ МРезультатов[0].Пустой() Тогда
			Возврат НСтр("ru = 'Есть остатки < 0 на текущую дату'");
		ИначеЕсли НЕ МРезультатов[1].Пустой() Тогда
			Возврат СтрЗаменить(НСтр("ru = 'Есть остатки < 0 на %КонецМесяца%'"), "%КонецМесяца%", Формат(КонецМесяца(СсылкаНаДокумент.Дата), "ДЛФ=D"));
		Иначе
			Возврат "";
		КонецЕсли;
	Иначе
		Результат = Запрос.Выполнить();
		
		Если НЕ Результат.Пустой() Тогда
			Возврат НСтр("ru = 'Есть остатки < 0 на текущую дату'");
		Иначе
			Возврат "";
		КонецЕсли;
	КонецЕсли;
	
КонецФункции
