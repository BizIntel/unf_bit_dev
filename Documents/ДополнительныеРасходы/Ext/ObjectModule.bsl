﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Процедура выполняет распределение затрат по количеству.
//
Процедура РаспределитьТабЧастьРасходыПоКоличеству() Экспорт
	
	ИсхСумма = 0;
	БазаРаспределенияКоличество = Запасы.Итог("Количество");
	ВсегоРасходы = Расходы.Итог("Всего");
	
	НОД = УправлениеНебольшойФирмойСервер.ПолучитьНОДДляМассива(Запасы.ВыгрузитьКолонку("Количество"), 1000);
	
	Если НОД = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого СтрокаЗапасы Из Запасы Цикл
		
		СтрокаЗапасы.Коэффициент = СтрокаЗапасы.Количество / НОД * 1000;
		СтрокаЗапасы.СуммаРасходов = ?(БазаРаспределенияКоличество <> 0, Окр((ВсегоРасходы - ИсхСумма) * СтрокаЗапасы.Количество / БазаРаспределенияКоличество, 2, 1),0);
		БазаРаспределенияКоличество = БазаРаспределенияКоличество - СтрокаЗапасы.Количество;
		ИсхСумма = ИсхСумма + СтрокаЗапасы.СуммаРасходов;
		
	КонецЦикла;
	
КонецПроцедуры // РаспределитьТабЧастьРасходыПоКоличеству()

// Процедура выполняет распределение затрат по сумме.
//
Процедура РаспределитьТабЧастьРасходыПоСумме() Экспорт
	
	ИсхСумма = 0;
	БазаРаспределенияСумма = Запасы.Итог("Сумма");
	ВсегоРасходы = Расходы.Итог("Всего");
	
	НОД = УправлениеНебольшойФирмойСервер.ПолучитьНОДДляМассива(Запасы.ВыгрузитьКолонку("Сумма"), 100);
	
	Если НОД = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого СтрокаЗапасы Из Запасы Цикл
		
		СтрокаЗапасы.Коэффициент = СтрокаЗапасы.Сумма / НОД * 100;
		СтрокаЗапасы.СуммаРасходов = ?(БазаРаспределенияСумма <> 0, Окр((ВсегоРасходы - ИсхСумма) * СтрокаЗапасы.Сумма / БазаРаспределенияСумма, 2, 1), 0);
		БазаРаспределенияСумма = БазаРаспределенияСумма - СтрокаЗапасы.Сумма;
		ИсхСумма = ИсхСумма + СтрокаЗапасы.СуммаРасходов;
		
	КонецЦикла;
	
КонецПроцедуры // РаспределитьТабЧастьРасходыПоСумме()

#КонецОбласти

#Область ПроцедурыЗаполненияДокумента

// Процедура заполняет авансы.
//
Процедура ЗаполнитьПредоплату() Экспорт
	
	Компания = УправлениеНебольшойФирмойСервер.ПолучитьОрганизацию(Организация);
	
	// Заполнение расшифровки предоплаты.
	Запрос = Новый Запрос;
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСПоставщикамиОстатки.Документ КАК Документ,
	|	РасчетыСПоставщикамиОстатки.Заказ КАК Заказ,
	|	РасчетыСПоставщикамиОстатки.ДокументДата КАК ДокументДата,
	|	РасчетыСПоставщикамиОстатки.Договор.ВалютаРасчетов КАК ВалютаРасчетов,
	|	СУММА(РасчетыСПоставщикамиОстатки.СуммаОстаток) КАК СуммаОстаток,
	|	СУММА(РасчетыСПоставщикамиОстатки.СуммаВалОстаток) КАК СуммаВалОстаток
	|ПОМЕСТИТЬ ВременнаяТаблицаРасчетыСПоставщикамиОстатки
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыСПоставщикамиОстатки.Договор КАК Договор,
	|		РасчетыСПоставщикамиОстатки.Документ КАК Документ,
	|		РасчетыСПоставщикамиОстатки.Документ.Дата КАК ДокументДата,
	|		РасчетыСПоставщикамиОстатки.Заказ КАК Заказ,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаВалОстаток, 0) КАК СуммаВалОстаток
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщиками.Остатки(
	|				,
	|				Организация = &Организация
	|					И Контрагент = &Контрагент
	|					И Договор = &Договор
	|					И Заказ В (&Заказ)
	|					И ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Аванс)) КАК РасчетыСПоставщикамиОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияДокументаРасчетыСПоставщиками.Договор,
	|		ДвиженияДокументаРасчетыСПоставщиками.Документ,
	|		ДвиженияДокументаРасчетыСПоставщиками.Документ.Дата,
	|		ДвиженияДокументаРасчетыСПоставщиками.Заказ,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.Сумма, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.Сумма, 0)
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА ДвиженияДокументаРасчетыСПоставщиками.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.СуммаВал, 0)
	|			ИНАЧЕ ЕСТЬNULL(ДвиженияДокументаРасчетыСПоставщиками.СуммаВал, 0)
	|		КОНЕЦ
	|	ИЗ
	|		РегистрНакопления.РасчетыСПоставщиками КАК ДвиженияДокументаРасчетыСПоставщиками
	|	ГДЕ
	|		ДвиженияДокументаРасчетыСПоставщиками.Регистратор = &Ссылка
	|		И ДвиженияДокументаРасчетыСПоставщиками.Период <= &Период
	|		И ДвиженияДокументаРасчетыСПоставщиками.Организация = &Организация
	|		И ДвиженияДокументаРасчетыСПоставщиками.Контрагент = &Контрагент
	|		И ДвиженияДокументаРасчетыСПоставщиками.Договор = &Договор
	|		И ДвиженияДокументаРасчетыСПоставщиками.Заказ В (&Заказ)
	|		И ДвиженияДокументаРасчетыСПоставщиками.ТипРасчетов = ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Аванс)) КАК РасчетыСПоставщикамиОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыСПоставщикамиОстатки.Документ,
	|	РасчетыСПоставщикамиОстатки.Заказ,
	|	РасчетыСПоставщикамиОстатки.ДокументДата,
	|	РасчетыСПоставщикамиОстатки.Договор.ВалютаРасчетов
	|
	|ИМЕЮЩИЕ
	|	СУММА(РасчетыСПоставщикамиОстатки.СуммаВалОстаток) < 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасчетыСПоставщикамиОстатки.Документ КАК Документ,
	|	РасчетыСПоставщикамиОстатки.Заказ КАК Заказ,
	|	РасчетыСПоставщикамиОстатки.ДокументДата КАК ДокументДата,
	|	РасчетыСПоставщикамиОстатки.ВалютаРасчетов КАК ВалютаРасчетов,
	|	-СУММА(РасчетыСПоставщикамиОстатки.СуммаУчета) КАК СуммаУчета,
	|	-СУММА(РасчетыСПоставщикамиОстатки.СуммаРасчетов) КАК СуммаРасчетов,
	|	-СУММА(РасчетыСПоставщикамиОстатки.СуммаПлатежа) КАК СуммаПлатежа,
	|	СУММА(РасчетыСПоставщикамиОстатки.СуммаУчета / ВЫБОР
	|			КОГДА ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаРасчетов, 0) <> 0
	|				ТОГДА РасчетыСПоставщикамиОстатки.СуммаРасчетов
	|			ИНАЧЕ 1
	|		КОНЕЦ) * (РасчетыСПоставщикамиОстатки.КурсыВалютыУчетаКурс / РасчетыСПоставщикамиОстатки.КурсыВалютыУчетаКратность) КАК Курс,
	|	1 КАК Кратность,
	|	РасчетыСПоставщикамиОстатки.КурсыВалютыДокументаКурс КАК КурсыВалютыДокументаКурс,
	|	РасчетыСПоставщикамиОстатки.КурсыВалютыДокументаКратность КАК КурсыВалютыДокументаКратность
	|ИЗ
	|	(ВЫБРАТЬ
	|		РасчетыСПоставщикамиОстатки.ВалютаРасчетов КАК ВалютаРасчетов,
	|		РасчетыСПоставщикамиОстатки.Документ КАК Документ,
	|		РасчетыСПоставщикамиОстатки.ДокументДата КАК ДокументДата,
	|		РасчетыСПоставщикамиОстатки.Заказ КАК Заказ,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаОстаток, 0) КАК СуммаУчета,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаВалОстаток, 0) КАК СуммаРасчетов,
	|		ЕСТЬNULL(РасчетыСПоставщикамиОстатки.СуммаОстаток, 0) * КурсыВалютыУчета.Курс * &КратностьВалютыДокумента / (&КурсВалютыДокумента * КурсыВалютыУчета.Кратность) КАК СуммаПлатежа,
	|		КурсыВалютыУчета.Курс КАК КурсыВалютыУчетаКурс,
	|		КурсыВалютыУчета.Кратность КАК КурсыВалютыУчетаКратность,
	|		&КурсВалютыДокумента КАК КурсыВалютыДокументаКурс,
	|		&КратностьВалютыДокумента КАК КурсыВалютыДокументаКратность
	|	ИЗ
	|		ВременнаяТаблицаРасчетыСПоставщикамиОстатки КАК РасчетыСПоставщикамиОстатки
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Период, Валюта = &ВалютаУчета) КАК КурсыВалютыУчета
	|			ПО (ИСТИНА)) КАК РасчетыСПоставщикамиОстатки
	|
	|СГРУППИРОВАТЬ ПО
	|	РасчетыСПоставщикамиОстатки.Документ,
	|	РасчетыСПоставщикамиОстатки.Заказ,
	|	РасчетыСПоставщикамиОстатки.ДокументДата,
	|	РасчетыСПоставщикамиОстатки.ВалютаРасчетов,
	|	РасчетыСПоставщикамиОстатки.КурсыВалютыУчетаКурс,
	|	РасчетыСПоставщикамиОстатки.КурсыВалютыУчетаКратность,
	|	РасчетыСПоставщикамиОстатки.КурсыВалютыДокументаКурс,
	|	РасчетыСПоставщикамиОстатки.КурсыВалютыДокументаКратность
	|
	|ИМЕЮЩИЕ
	|	-СУММА(РасчетыСПоставщикамиОстатки.СуммаРасчетов) > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДокументДата";
	
	Запрос.УстановитьПараметр("Заказ", ?(Контрагент.ВестиРасчетыПоЗаказам, ЗаказПоставщику, Документы.ЗаказПоставщику.ПустаяСсылка()));
	
	Запрос.УстановитьПараметр("Организация", Компания);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("Договор", Договор);
	Запрос.УстановитьПараметр("Период", Дата);
	Запрос.УстановитьПараметр("ВалютаДокумента", ВалютаДокумента);
	Запрос.УстановитьПараметр("ВалютаУчета", Константы.ВалютаУчета.Получить());
	Если Договор.ВалютаРасчетов = ВалютаДокумента Тогда
		Запрос.УстановитьПараметр("КурсВалютыДокумента", Курс);
		Запрос.УстановитьПараметр("КратностьВалютыДокумента", Кратность);
	Иначе
		Запрос.УстановитьПараметр("КурсВалютыДокумента", 1);
		Запрос.УстановитьПараметр("КратностьВалютыДокумента", 1);
	КонецЕсли;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	Запрос.Текст = ТекстЗапроса;
	
	Предоплата.Очистить();
	СуммаОсталосьРаспределить = Расходы.Итог("Всего");
	СуммаОсталосьРаспределить = УправлениеНебольшойФирмойСервер.ПересчитатьИзВалютыВВалюту(
		СуммаОсталосьРаспределить,
		?(Договор.ВалютаРасчетов = ВалютаДокумента, Курс, 1),
		Курс,
		?(Договор.ВалютаРасчетов = ВалютаДокумента, Кратность, 1),
		Кратность
	);
	
	ВыборкаРезультатаЗапроса = Запрос.Выполнить().Выбрать();
	
	Пока СуммаОсталосьРаспределить > 0 Цикл
		
		Если ВыборкаРезультатаЗапроса.Следующий() Тогда
			
			Если ВыборкаРезультатаЗапроса.СуммаРасчетов <= СуммаОсталосьРаспределить Тогда // сумма остатка меньше или равна чем осталось распределить
				
				НоваяСтрока = Предоплата.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРезультатаЗапроса);
				СуммаОсталосьРаспределить = СуммаОсталосьРаспределить - ВыборкаРезультатаЗапроса.СуммаРасчетов;
				
			Иначе // сумма остатка больше чем нужно распределить
				
				НоваяСтрока = Предоплата.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаРезультатаЗапроса);
				НоваяСтрока.СуммаРасчетов = СуммаОсталосьРаспределить;
				НоваяСтрока.СуммаПлатежа = УправлениеНебольшойФирмойСервер.ПересчитатьИзВалютыВВалюту(
					НоваяСтрока.СуммаРасчетов,
					ВыборкаРезультатаЗапроса.Курс,
					ВыборкаРезультатаЗапроса.КурсыВалютыДокументаКурс,
					ВыборкаРезультатаЗапроса.Кратность,
					ВыборкаРезультатаЗапроса.КурсыВалютыДокументаКратность
				);
				СуммаОсталосьРаспределить = 0;
				
			КонецЕсли;
			
		Иначе
			
			СуммаОсталосьРаспределить = 0;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

// Процедура заполнения документа на основании приходная накладной.
//
// Параметры:
//	ДокументОснование - ДокументСсылка.ПриходнаяНакладная - приходная накладная
//	ДанныеЗаполнения - Структура - Данные заполнения документа
//	
Процедура ЗаполнитьПоПриходнойНакладной(ДанныеЗаполнения) Экспорт
	
	Организация = ДанныеЗаполнения.Организация;
	Контрагент = ДанныеЗаполнения.Контрагент;
	Договор = ДанныеЗаполнения.Договор;
	СтруктурнаяЕдиница = ДанныеЗаполнения.СтруктурнаяЕдиница;
	ВалютаДокумента = ДанныеЗаполнения.ВалютаДокумента;
	СуммаВключаетНДС = ДанныеЗаполнения.СуммаВключаетНДС;
	НДСВключатьВСтоимость = ДанныеЗаполнения.НДСВключатьВСтоимость;
	НалогообложениеНДС = ДанныеЗаполнения.НалогообложениеНДС; 
	Если ВалютаДокумента = Константы.НациональнаяВалюта.Получить() Тогда
		Курс = ДанныеЗаполнения.Курс;
		Кратность = ДанныеЗаполнения.Кратность;
	Иначе
		СтруктураПоВалюте = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Дата, Новый Структура("Валюта", Договор.ВалютаРасчетов));
		Курс = СтруктураПоВалюте.Курс;
		Кратность = СтруктураПоВалюте.Кратность;
	КонецЕсли;
	
	// Заполнение табличной части документа.
	Запасы.Очистить();
	Для каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.Запасы Цикл
		
		НоваяСтрока = Запасы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТабличнойЧасти);
		НоваяСтрока.ДокументПоступления = ДанныеЗаполнения.Ссылка;
		
		Если ТипЗнч(СтрокаТабличнойЧасти.Заказ) = Тип("ДокументСсылка.ЗаказПоставщику")
			И ПолучитьФункциональнуюОпцию("РезервированиеЗапасов") Тогда
			НоваяСтрока.ЗаказПокупателя = СтрокаТабличнойЧасти.Заказ.ЗаказПокупателя;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьПоПриходнойНакладной()

// Процедура заполнения документа на основании авансовый отчет.
//
// Параметры:
//	ДокументОснование - ДокументСсылка.АвансовыйОтчет - авансовый отчет
//	ДанныеЗаполнения - Структура - Данные заполнения документа
//	
Процедура ЗаполнитьПоАвансовомуОтчету(ДанныеЗаполнения) Экспорт
	
	Организация = ДанныеЗаполнения.Организация;
	ВалютаДокумента = ДанныеЗаполнения.ВалютаДокумента;
	СуммаВключаетНДС = ДанныеЗаполнения.СуммаВключаетНДС;
	НДСВключатьВСтоимость = ДанныеЗаполнения.НДСВключатьВСтоимость;
	Курс = ДанныеЗаполнения.Курс;
	Кратность = ДанныеЗаполнения.Кратность;
	НалогообложениеНДС = ДанныеЗаполнения.НалогообложениеНДС; 
	
	// Заполнение табличной части документа.	
	Запасы.Очистить();
	Для каждого СтрокаТабличнойЧасти Из ДанныеЗаполнения.Запасы Цикл
		
		НоваяСтрока = Запасы.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТабличнойЧасти);
		НоваяСтрока.ДокументПоступления	= ДанныеЗаполнения.Ссылка;
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьПоАвансовомуОтчету()

#КонецОбласти

#Область ОбработчикиСобыий

// Процедура - обработчик события ОбработкаЗаполнения.
//
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	СтратегияЗаполнения = Новый Соответствие;
	СтратегияЗаполнения[Тип("ДокументСсылка.ПриходнаяНакладная")] = "ЗаполнитьПоПриходнойНакладной";
	СтратегияЗаполнения[Тип("ДокументСсылка.АвансовыйОтчет")] = "ЗаполнитьПоАвансовомуОтчету";
	
	ЗаполнениеОбъектовУНФ.ЗаполнитьДокумент(ЭтотОбъект, ДанныеЗаполнения, СтратегияЗаполнения);
	
КонецПроцедуры // ОбработкаЗаполнения()

// Процедура - обработчик события ОбработкаПроверкиЗаполнения объекта.
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	Если Запасы.Итог("СуммаРасходов") <> Расходы.Итог("Всего") Тогда
		
		ТекстСообщения = НСтр("ru = 'Сумма услуг не равна распределенной сумме по запасам!'");
		УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
			,
			ТекстСообщения,
			Неопределено,
			Неопределено,
			Неопределено,
			Отказ
		);
		
	КонецЕсли;
	
	Если НЕ Контрагент.ВестиРасчетыПоДоговорам Тогда
		УправлениеНебольшойФирмойСервер.УдалитьПроверяемыйРеквизит(ПроверяемыеРеквизиты, "Договор");
	КонецЕсли;
	
КонецПроцедуры // ОбработкаПроверкиЗаполнения()

// Процедура - обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контрагент)
	И НЕ Контрагент.ВестиРасчетыПоДоговорам
	И НЕ ЗначениеЗаполнено(Договор) Тогда
		Договор = Контрагент.ДоговорПоУмолчанию;
	КонецЕсли;
	
	СуммаДокумента = Расходы.Итог("Всего");
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ОбработкаПроведения объекта.
//
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Инициализация дополнительных свойств для проведения документа.
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.ДополнительныеРасходы.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	УправлениеНебольшойФирмойСервер.ОтразитьЗапасы(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗакупки(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьЗаказыПоставщикам(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьРасчетыСПоставщиками(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходы(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходыКассовыйМетод(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходыНераспределенные(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьДоходыИРасходыОтложенные(ДополнительныеСвойства, Движения, Отказ);
	УправлениеНебольшойФирмойСервер.ОтразитьУправленческий(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей.
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.ДополнительныеРасходы.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
	ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц.Закрыть();
	
КонецПроцедуры // ОбработкаПроведения()

// Процедура - обработчик события ОбработкаУдаленияПроведения объекта.
//
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	УправлениеНебольшойФирмойСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	УправлениеНебольшойФирмойСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	УправлениеНебольшойФирмойСервер.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.ДополнительныеРасходы.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
	// Подчиненная счет-фактура (полученная)
	Если НЕ Отказ Тогда
		
		КонтрольПодчиненнойСчетФактуры();
		
	КонецЕсли;
	
КонецПроцедуры // ОбработкаУдаленияПроведения()

// Процедура - обработчик события ПриКопировании объекта.
//
Процедура ПриКопировании(ОбъектКопирования)
	
	Предоплата.Очистить();
	
КонецПроцедуры // ПриКопировании()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура отмены проведения у подченненой счет фактуры (полученной)
//
Процедура КонтрольПодчиненнойСчетФактуры()
	
	СтруктураСчетаФактуры = УправлениеНебольшойФирмойСервер.ПолучитьПодчиненныйСчетФактуру(Ссылка, Истина);
	Если СтруктураСчетаФактуры = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СчетФактура	 = СтруктураСчетаФактуры.Ссылка;
	Если Не СчетФактура.Проведен Тогда
		Возврат;
	КонецЕсли;
	
	ТекстСообщения = НСтр("ru = 'В связи с отсутствием движений у документа %ПредставлениеТекущегоДокумента% распроводится %ПредставлениеСчетФактуры%.'");
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПредставлениеТекущегоДокумента%", """Поступление дополнительных расходов № " + Номер + " от " + Формат(Дата, "ДФ=dd.MM.yyyy") + """");
	ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПредставлениеСчетФактуры%", """Счет фактура (полученная) № " + СтруктураСчетаФактуры.Номер + " от " + СтруктураСчетаФактуры.Дата + """");
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	
	СчетФактураОбъект = СчетФактура.ПолучитьОбъект();
	СчетФактураОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
	
КонецПроцедуры //КонтрольПодчиненнойСчетФактуры()

#КонецОбласти

#КонецЕсли