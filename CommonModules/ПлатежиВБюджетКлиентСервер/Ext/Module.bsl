﻿#Область ОсновныеПравила
Функция НачалоДействияПриказа90н() Экспорт
	
	// Приказ Минфина №90н от 08.06.2015.
	
	Возврат '2016-01-01';
	
КонецФункции

Функция НачалоДействияПриказа2017_90н() Экспорт
	
	// Приказ Минфина №90н от 08.06.2015.
	
	Возврат '2017-01-01';
	
КонецФункции

Функция НачалоДействияПриказа126н() Экспорт
	
	// Приказ Минфина №126н от 30.10.2014.
	
	Возврат '2015-01-01';
	
КонецФункции

Функция ВидПеречисления(Знач КБК, Знач Период) Экспорт
	
	// Вид перечисления определяет набор правил, которые используются для идентификации платежа.
	// Эти правила определены приложениями №№ 2-4 к приказу Минфина 107Н
	// НалоговыйПлатеж соответствует приложению 2
	// ТаможенныйПлатеж - приложению 3
	// ИнойПлатеж       - приложению 4
	
	Если НЕ КБКЗадан(КБК) Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПеречисленийВБюджет.ИнойПлатеж");
	КонецЕсли;
	
	Если ПлатежАдминистрируетсяНалоговымиОрганами(КБК) Тогда
		
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПеречисленийВБюджет.НалоговыйПлатеж");
		
	ИначеЕсли ПлатежАдминистрируетсяТаможеннымиОрганами(КБК)
		ИЛИ ЭтоДоходыОтВнешнеэкономическойДеятельности(КБК) Тогда
		
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПеречисленийВБюджет.ТаможенныйПлатеж");
		
	ИначеЕсли ЭтоСтраховыеВзносы(КБК) Тогда
		
		Если ДействуетПриказ107н(Период) Тогда
			
			Возврат ПредопределенноеЗначение("Перечисление.ВидыПеречисленийВБюджет.ИнойПлатеж");
			
		Иначе
			
			// Приказ 106н ясности не дает
			Возврат ПредопределенноеЗначение("Перечисление.ВидыПеречисленийВБюджет.НалоговыйПлатеж");
			
		КонецЕсли;
		
	Иначе
		
		Возврат ПредопределенноеЗначение("Перечисление.ВидыПеречисленийВБюджет.ИнойПлатеж");
		
	КонецЕсли;
	
КонецФункции

Функция НачалоДействияПриказа107н() Экспорт
	
	// Приказ Минфина №107н от 12.11.2013.
	// Опубликован 24.01.2014 и вступает в силу по истечении 10 дней с даты публикации.
	
	Возврат '2014-02-04';
	
КонецФункции

Функция ДействуетПриказ107н(Период) Экспорт
	
	Возврат Период = Неопределено
		ИЛИ Период >= НачалоДействияПриказа107н();
	
КонецФункции

Функция ДействуетПриказ90н(Период) Экспорт
	
	Возврат Период = Неопределено
		ИЛИ Период >= НачалоДействияПриказа90н();
	
КонецФункции

Функция ДействуетПриказ126н(Период) Экспорт
	
	Возврат Период = Неопределено
		ИЛИ Период >= НачалоДействияПриказа126н();
	
КонецФункции

Функция ВидГосударственногоОргана(КБК) Экспорт
	
	Если ПустаяСтрока(КБК) Тогда
		Возврат ПредопределенноеЗначение("Перечисление.ВидыГосударственныхОрганов.ПустаяСсылка");
	КонецЕсли;
	
	КодГлавногоАдминистратора = ПлатежиВБюджетКлиентСервер.КодГлавногоАдминистратора(КБК);
	
	Если ПустаяСтрока(КБК) ИЛИ КодГлавногоАдминистратора = "182" Тогда
		ВидГосударственногоОргана = ПредопределенноеЗначение("Перечисление.ВидыГосударственныхОрганов.НалоговыйОрган");
	ИначеЕсли КодГлавногоАдминистратора = "392" Тогда
		ВидГосударственногоОргана = ПредопределенноеЗначение("Перечисление.ВидыГосударственныхОрганов.ОрганПФР");
	ИначеЕсли КодГлавногоАдминистратора = "393" Тогда
		ВидГосударственногоОргана = ПредопределенноеЗначение("Перечисление.ВидыГосударственныхОрганов.ОрганФСС");
	Иначе
		ВидГосударственногоОргана = ПредопределенноеЗначение("Перечисление.ВидыГосударственныхОрганов.Прочий");
	КонецЕсли;
	
	Возврат ВидГосударственногоОргана;
	
КонецФункции

Функция КодАдминистрированияНалоговымиОрганами() Экспорт
	
	Возврат "182";
	
КонецФункции

Функция КодАдминистрированияПенсионнымФондом() Экспорт
	
	Возврат "392";
	
КонецФункции

Функция КодАдминистрированияФСС() Экспорт
	
	Возврат "393";
	
КонецФункции

Функция НовыйАдминистраторСтраховыхВзносов(Период) Экспорт
	
	Возврат Период <> Неопределено
		// Приказ Минфина №90н от 08.06.2015.
		И Период >= '2017-01-01';
	
КонецФункции

Функция ЭтоВзносыНаПенсионноеСтрахование(ВидНалога) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ВидНалога) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для каждого ВидВзноса Из ВидыВзносовНаПенсионноеСтрахование() Цикл
		Если ВидВзноса = ВидНалога Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция ЭтоВзносыНаСоциальноеСтрахование(ВидНалога) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ВидНалога) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Для каждого ВидВзноса Из ВидыНаСоциальноеСтрахование() Цикл
		Если ВидВзноса = ВидНалога Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

Функция ВидыВзносовНаПенсионноеСтрахование()
	
	Взносы = Новый Массив;
	Взносы.Добавить(ПредопределенноеЗначение("Перечисление.ВидыНалогов.СтраховыеВзносы_ПФР_СтраховаяЧасть"));
	Взносы.Добавить(ПредопределенноеЗначение("Перечисление.ВидыНалогов.СтраховыеВзносы_ФФОМС"));
	Взносы.Добавить(ПредопределенноеЗначение("Перечисление.ВидыНалогов.ДополнительныеВзносы_ПФР_ВредныеУсловия"));
	Взносы.Добавить(ПредопределенноеЗначение("Перечисление.ВидыНалогов.ДополнительныеВзносы_ПФР_ЛетныеЭкипажи"));
	Взносы.Добавить(ПредопределенноеЗначение("Перечисление.ВидыНалогов.ДополнительныеВзносы_ПФР_ТяжелыеУсловия"));
	Взносы.Добавить(ПредопределенноеЗначение("Перечисление.ВидыНалогов.ДополнительныеВзносы_ПФР_Шахтеры"));
	Взносы.Добавить(ПредопределенноеЗначение("Перечисление.ВидыНалогов.ФиксированныеВзносы_ФФОМС"));
	Взносы.Добавить(ПредопределенноеЗначение("Перечисление.ВидыНалогов.ФиксированныеВзносы_ПФР_СтраховаяЧасть"));
	
	Возврат Взносы;
	
КонецФункции

Функция ВидыНаСоциальноеСтрахование()
	
	Взносы = Новый Массив;
	Взносы.Добавить(ПредопределенноеЗначение("Перечисление.ВидыНалогов.СтраховыеВзносы_ФСС"));
	
	Возврат Взносы;
	
КонецФункции

#КонецОбласти

#Область КодыБюджетнойКлассификации

// Приказ Минфина от 01.07.13 г. N 65н

//┌──────────────────────────────────────────────────────────────────────────────────────┐
//│                     Структура кода классификации доходов бюджетов                    │
//├──────────────┬─────────────────────────────────────────┬───────────┬─────────────────┤
//│ Код главного │        Код вида доходов бюджетов        │Код подвида│Код классификации│
//│администратора├───────┬───────┬───────┬─────────┬───────┤  доходов  │ операций сектора│
//│   доходов    │группа │под-   │статья │подстатья│элемент│ бюджетов  │ государственного│
//│   бюджета    │доходов│группа │доходов│ доходов │доходов│           │   управления,   │
//│              │       │доходов│       │         │       │           │  относящихся к  │
//│              │       │       │       │         │       │           │ доходам бюджетов│
//├────┬────┬────┼───────┼───┬───┼───┬───┼──┬──┬───┼───┬───┼──┬──┬──┬──┼─────┬─────┬─────┤
//│ 1  │ 2  │ 3  │   4   │ 5 │ 6 │ 7 │ 8 │9 │10│11 │12 │13 │14│15│16│17│ 18  │ 19  │  20 │
//└────┴────┴────┴───────┴───┴───┴───┴───┴──┴──┴───┴───┴───┴──┴──┴──┴──┴─────┴─────┴─────┘

Функция ПлатежАдминистрируетсяНалоговымиОрганами(КБК) Экспорт
	
	Возврат КодГлавногоАдминистратора(КБК) = "182";
	
КонецФункции

Функция ПлатежАдминистрируетсяПенсионнымФондом(КБК) Экспорт
	
	Возврат КодГлавногоАдминистратора(КБК) = "392";
	
КонецФункции

Функция ПлатежАдминистрируетсяФСС(КБК) Экспорт
	
	Возврат КодГлавногоАдминистратора(КБК) = "393";
	
КонецФункции

Функция ПлатежАдминистрируетсяТаможеннымиОрганами(КБК) Экспорт
	
	Возврат КодГлавногоАдминистратора(КБК) = "153";
	
КонецФункции

Функция ЭтоСтраховыеВзносы(КБК) Экспорт
	
	Возврат ПодгруппаДоходов(КБК) = "102"; // страховые взносы на обязательное социальное страхование;
	
КонецФункции

Функция ЭтоДоходыОтВнешнеэкономическойДеятельности(КБК)
	
	Возврат ПодгруппаДоходов(КБК) = "110"; // доходы от внешнеэкономической деятельности;
	
КонецФункции

Функция ПодгруппаДоходов(КБК)
	
	Возврат ЭлементКБК(КБК, "ПодгруппаДоходов");
	
КонецФункции

Функция ЭлементКБК(КБК, ИмяЭлементаКБК) Экспорт
	
	РасположениеЭлемента = РасположениеЭлементаКБК(ИмяЭлементаКБК);
	
	Возврат Сред(КБК, РасположениеЭлемента.Начало, РасположениеЭлемента.Длина);
	
КонецФункции

Функция РасположениеЭлементаКБК(ИмяЭлементаКБК) Экспорт
	
	Результат = Новый Структура("Начало, Длина", 0, 0);
	Если ИмяЭлементаКБК = "КодГлавногоАдминистратора" Тогда
		Результат.Начало = 1;
		Результат.Длина  = 3;
	ИначеЕсли ИмяЭлементаКБК = "КодГруппыДоходов" Тогда
		Результат.Начало = 4;
		Результат.Длина  = 1;
	ИначеЕсли ИмяЭлементаКБК = "КодПодгруппыДоходов" Тогда
		Результат.Начало = 5;
		Результат.Длина  = 2;
	ИначеЕсли ИмяЭлементаКБК = "ПодгруппаДоходов" Тогда
		Результат.Начало = 4;
		Результат.Длина  = 3;
	ИначеЕсли ИмяЭлементаКБК = "КодСтатьиДоходов" Тогда
		Результат.Начало = 7;
		Результат.Длина  = 2;
	ИначеЕсли ИмяЭлементаКБК = "КодВидаДоходов" Тогда
		Результат.Начало = 4;
		Результат.Длина  = 10;
	ИначеЕсли ИмяЭлементаКБК = "КодЭлементаДоходов" Тогда
		Результат.Начало = 12;
		Результат.Длина  = 2;
	ИначеЕсли ИмяЭлементаКБК = "КодПодвидаДоходов" Тогда
		Результат.Начало = 14;
		Результат.Длина  = 4;
	ИначеЕсли ИмяЭлементаКБК = "КодОперацииСектораУправления" Тогда
		Результат.Начало = 18;
		Результат.Длина  = 3;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция КодГлавногоАдминистратора(КБК) Экспорт
	
	Возврат ЭлементКБК(КБК, "КодГлавногоАдминистратора");
	
КонецФункции

Функция КБКЗадан(КБК) Экспорт
	
	Если НЕ РеквизитЗаполнен(КБК) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если СтрДлина(СокрП(КБК)) <> 20 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ПустойКодГлавногоАдминистратора() Экспорт
	
	Результат = "";
	РасположениеЭлемента = РасположениеЭлементаКБК("КодГлавногоАдминистратора");
	Для Счетчик = 1 По РасположениеЭлемента.Длина Цикл
		Результат = Результат + "0";
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция КодВидаДоходов(КБК) Экспорт
	
	Возврат ЭлементКБК(КБК, "КодВидаДоходов");
	
КонецФункции

Функция ШаблонКБК(КБК, ПустойКодПодвидаДоходов = Истина) Экспорт
	
	Если НЕ КБКЗадан(КБК) Тогда
		Возврат "";
	КонецЕсли;
	
	Если ПустойКодПодвидаДоходов Тогда
		Возврат КодВидаДоходов(КБК) + ПустойКодПодвидаДоходов() + КодОперацииСектораУправления(КБК);
	Иначе
		Возврат КодВидаДоходов(КБК) + КодПодвидаДоходов(КБК)    + КодОперацииСектораУправления(КБК);
	КонецЕсли;
	
КонецФункции

Функция ПустойКодПодвидаДоходов() Экспорт
	
	Результат = "";
	РасположениеЭлемента = РасположениеЭлементаКБК("КодПодвидаДоходов");
	Для Счетчик = 1 По РасположениеЭлемента.Длина Цикл
		Результат = Результат + "0";
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция КодОперацииСектораУправления(КБК) Экспорт
	
	Возврат ЭлементКБК(КБК, "КодОперацииСектораУправления"); // КОСГУ
	
КонецФункции

Функция НовыеРеквизитыПлатежаВБюджет(Объект, ПеречислениеВБюджет = Истина) Экспорт
	
	РеквизитыПлатежаВБюджет = Новый Структура;
	
	Если ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.ПлатежноеПоручение") Тогда
		РеквизитыДокумента = РеквизитыДокумента_ПлатежноеПоручение();
	ИначеЕсли ТипЗнч(Объект.Ссылка) = Тип("ДокументСсылка.РасходИзКассы") Тогда
		РеквизитыДокумента = РеквизитыДокумента_РасходныйКассовыйОрдер();
	КонецЕсли;
	
	Для Каждого Реквизит Из РеквизитыДокумента Цикл
		РеквизитыПлатежаВБюджет.Вставить(Реквизит.Значение)
	КонецЦикла;
	
	Если ПеречислениеВБюджет Тогда
		ЗаполнитьЗначенияСвойств(РеквизитыПлатежаВБюджет, Объект);
	КонецЕсли;
	
	Возврат РеквизитыПлатежаВБюджет;
	
КонецФункции

Функция РеквизитыПлатежаВБюджет() Экспорт
	
	Реквизиты = Новый Соответствие;
	
	Реквизиты.Вставить("ВидПеречисления",      "ВидПеречисленияВБюджет");
	Реквизиты.Вставить("ИдентификаторПлатежа", "ИдентификаторПлатежа");
	Реквизиты.Вставить("СтатусПлательщика",    "СтатусСоставителя");
	Реквизиты.Вставить("КБК",                  "КодБК");
	Реквизиты.Вставить("КодТерритории",        "КодОКАТО");
	Реквизиты.Вставить("ОснованиеПлатежа",     "ПоказательОснования");
	Реквизиты.Вставить("НалоговыйПериод",      "ПоказательПериода");
	Реквизиты.Вставить("НомерДокумента",       "ПоказательНомера");
	Реквизиты.Вставить("ДатаДокумента",        "ПоказательДаты");
	Реквизиты.Вставить("ТипПлатежа",           "ПоказательТипа");
	
	Возврат Реквизиты;
	
КонецФункции

Функция РеквизитыДокумента_ПлатежноеПоручение() Экспорт
	
	Реквизиты = РеквизитыПлатежаВБюджет();
	
	Реквизиты.Вставить("НазначениеПлатежа",  "НазначениеПлатежа");
	Реквизиты.Вставить("ОчередностьПлатежа", "ОчередностьПлатежа");
	
	Возврат Реквизиты;
	
КонецФункции

Функция РеквизитыДокумента_РасходныйКассовыйОрдер() Экспорт
	
	Реквизиты = РеквизитыПлатежаВБюджет();
	
	Реквизиты.Вставить("НазначениеПлатежа", "Основание");
	
	Возврат Реквизиты;
	
КонецФункции

Функция ПоказателиНалоговогоПериода(Организация, ВидНалога, Период) Экспорт
	
	Показатели = ПоказателиПериода();
	
	Если ВидНалога = ПредопределенноеЗначение("Перечисление.ВидыНалогов.НДС") Тогда
		// Особенность НДС в том, что он уплачивается несколькими (ежемесячными) платежами,
		// каждый из которых относится к одному и тому же периоду (кварталу).
		// Из текста правил оформления  документов нельзя сделать однозначный вывод, что указывать в данном случае - месяц или квартал.
		// Сейчас местные УФНС рекомендуют указывать значение "КВ" (квартал).
		НалоговыйПериодДляПлатежейВБюджет = ПредопределенноеЗначение("Перечисление.Периодичность.Квартал");
		
	ИначеЕсли ВидНалога = ПредопределенноеЗначение("Перечисление.ВидыНалогов.НДФЛ_ИП") Тогда
		
		// Если по годовому платежу предусматривается более одного срока уплаты налогового платежа
		// и установлены конкретные даты уплаты, то указываются эти даты.
		
		НалоговыйПериодДляПлатежейВБюджет = Неопределено;
		
	ИначеЕсли ЭтоФиксированныеВзносы(ВидНалога) Тогда
		
		НалоговыйПериодДляПлатежейВБюджет = ПредопределенноеЗначение("Перечисление.Периодичность.Год");
		
	КонецЕсли;
	
	Если НалоговыйПериодДляПлатежейВБюджет <> Неопределено Тогда
		
		ПериодичностьПоКлассификатору = ПериодичностьПоКлассификатору(НалоговыйПериодДляПлатежейВБюджет);
		ПоказательПериода = ПлатежиВБюджетКлиентСервер.НалоговыйПериод(Период, ПериодичностьПоКлассификатору);
		Показатели.Период                         = Период;
		Показатели.ПоказательПериода              = ПоказательПериода;
		Показатели.ПредставлениеНалоговогоПериода = ПлатежиВБюджетКлиентСервер.ПредставлениеНалоговогоПериода(ПоказательПериода);
		
	ИначеЕсли ВидНалога =  ПредопределенноеЗначение("Перечисление.ВидыНалогов.НДФЛ") Тогда
		
		ПериодУплаты = НачалоМесяца(Период) - 1;
		Показатели.Период                         = ПериодУплаты; // НДФЛ платим в месяце, следующем за окончанием налогового периода
		Показатели.ПоказательПериода              = НалоговыйПериод(ПериодУплаты, ПлатежиВБюджетКлиентСервер.ПериодичностьМесяц());
		Показатели.ПредставлениеНалоговогоПериода = ПредставлениеНалоговогоПериода(Показатели.ПоказательПериода);
		
	ИначеЕсли ВидНалога =  ПредопределенноеЗначение("Перечисление.ВидыНалогов.НДС") Тогда // Предприятие на УСН может заплатить НДС
		
		ПериодУплаты = НачалоКвартала(Период) - 1;
		ПоказательПериода = ПлатежиВБюджетКлиентСервер.НалоговыйПериод(
			ПериодУплаты, ПериодичностьПоКлассификатору(ПредопределенноеЗначение("Перечисление.Периодичность.Квартал")));
		Показатели.Период                         = ПериодУплаты;
		Показатели.ПоказательПериода              = ПоказательПериода;
		Показатели.ПредставлениеНалоговогоПериода = ПредставлениеНалоговогоПериода(ПоказательПериода);
		
	Иначе
		
		Показатели.Период                         = Период;
		Показатели.ПоказательПериода              = НалоговыйПериод(Период, ПлатежиВБюджетКлиентСервер.ПлатежПоКонкретнойДате());
		Показатели.ПредставлениеНалоговогоПериода = ПредставлениеНалоговогоПериода(Показатели.ПоказательПериода);
		
	КонецЕсли;
	
	Возврат Показатели;
	
КонецФункции

Функция ПоказателиПериода() Экспорт
	
	Возврат Новый Структура("Период, ПоказательПериода, ПредставлениеНалоговогоПериода",
		'00010101', "", "");
	
КонецФункции

Функция ПериодичностьПоКлассификатору(Периодичность) Экспорт
	
	Если Периодичность =  ПредопределенноеЗначение("Перечисление.Периодичность.Год") Тогда
		
		Возврат ПлатежиВБюджетКлиентСервер.ПериодичностьГод();
		
	ИначеЕсли Периодичность =  ПредопределенноеЗначение("Перечисление.Периодичность.Полугодие") Тогда
		
		Возврат ПлатежиВБюджетКлиентСервер.ПериодичностьПолугодие();
		
	ИначеЕсли Периодичность =  ПредопределенноеЗначение("Перечисление.Периодичность.Квартал") Тогда
		
		Возврат ПлатежиВБюджетКлиентСервер.ПериодичностьКвартал();
		
	ИначеЕсли Периодичность =  ПредопределенноеЗначение("Перечисление.Периодичность.Месяц") Тогда
		
		Возврат ПлатежиВБюджетКлиентСервер.ПериодичностьМесяц();
		
	Иначе
		
		Возврат ПлатежиВБюджетКлиентСервер.ПлатежПоКонкретнойДате();
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти



#Область ОбеспечениеВыполненияПравил

Функция РеквизитЗаполнен(Значение) Экспорт
	
	Возврат ЗначениеЗаполнено(Значение) И СокрП(Значение) <> НезаполненноеЗначение();
	
КонецФункции

// Незаполненное значение ("0")
//
Функция НезаполненноеЗначение() Экспорт
	
	// При невозможности указать конкретное значение, указывается ноль "0".
	// Наличие незаполненных реквизитов не допускается.
	
	Возврат "0";
	
КонецФункции

Функция ПениПроцентыРаздельно(КБК, Период) Экспорт
	
	Если ПлатежАдминистрируетсяНалоговымиОрганами(КБК) Тогда
		
		Возврат ДействуетПриказ126н(Период);
		
	ИначеЕсли ПлатежАдминистрируетсяПенсионнымФондом(КБК) Тогда
		
		Возврат ДействуетПриказ90н(Период);
		
	ИначеЕсли ПлатежАдминистрируетсяФСС(КБК) Тогда
		
		Возврат ДействуетПриказ90н(Период);
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция СтраховыеВзносыРаздельно(Период) Экспорт
	
	Возврат ДействуетПриказ90н(Период);
	
КонецФункции

Функция ЭтоКБКШтраф(КБК) Экспорт
	
	// Из этого правила могут быть исключения, но они редкие и мы их не обслуживаем
	
	КодПодвидаДоходов = КодПодвидаДоходов(КБК);
	Возврат Лев(КодПодвидаДоходов, 1) = "3";
	
	// В некоторых случаях штраф может также определяться по типу платежа
	
КонецФункции

Функция ЭтоКБКПени(КБК) Экспорт
	
	КодПодвидаДоходов = КодПодвидаДоходов(КБК);
	Возврат Лев(КодПодвидаДоходов, 2) = "21";
	
КонецФункции

Функция ЭтоКБКПроценты(КБК) Экспорт
	
	КодПодвидаДоходов = КодПодвидаДоходов(КБК);
	Возврат Лев(КодПодвидаДоходов, 2) = "22";
	
КонецФункции

Функция ЭтоКБКПениПроценты(КБК) Экспорт
	
	// Из этого правила могут быть исключения, но они редкие и мы их не обслуживаем
	КодПодвидаДоходов = КодПодвидаДоходов(КБК);
	Возврат Лев(КодПодвидаДоходов, 1) = "2";
	
	// В некоторых случаях может определяться по типу платежа - см. ТипПлатежаПени()
	
КонецФункции

Функция КодПодвидаДоходов(КБК) Экспорт
	
	Возврат ЭлементКБК(КБК, "КодПодвидаДоходов");
	
КонецФункции

Функция ЭтоФиксированныеВзносы(ВидНалога) Экспорт
	
	Если Не ЗначениеЗаполнено(ВидНалога) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат (ВидНалога = ПредопределенноеЗначение("Перечисление.ВидыНалогов.ФиксированныеВзносы_ПФР_СтраховаяЧасть")
		Или ВидНалога = ПредопределенноеЗначение("Перечисление.ВидыНалогов.ФиксированныеВзносы_ФФОМС")
		Или ВидНалога = ПредопределенноеЗначение("Перечисление.ВидыНалогов.ФиксированныеВзносы_ФСС")
		Или ВидНалога = ПредопределенноеЗначение("Перечисление.ВидыНалогов.ФиксированныеВзносы_ПФР_НакопительнаяЧасть"));
	
КонецФункции

Функция ЭтоКБКНалогиВзносы(КБК) Экспорт
	
	КодПодвидаДоходов = КодПодвидаДоходов(КБК);
	Возврат Лев(КодПодвидаДоходов, 1) = "1";
	
КонецФункции

#КонецОбласти

#Область СпециальныеКлассификаторы

Функция ПериодичностьГод() Экспорт
	
	Возврат "ГД";
	
КонецФункции

Функция ПериодичностьПолугодие() Экспорт
	
	Возврат "ПЛ";
	
КонецФункции

Функция ПериодичностьКвартал() Экспорт
	
	Возврат "КВ";
	
КонецФункции

Функция ПериодичностьМесяц() Экспорт
	
	Возврат "МС";
	
КонецФункции

Функция ПлатежПоКонкретнойДате() Экспорт
	
	Возврат "-"; // Важно, чтобы отличалось от незаполненного значения
	
КонецФункции

Функция НалоговыйПериод(Период, Знач Периодичность, Знач Год = Неопределено, Знач НомерПериода = Неопределено) Экспорт
	
	Если Периодичность = НезаполненноеЗначение()
		ИЛИ ВидыНалоговыхПериодов().НайтиПоЗначению(Периодичность) = Неопределено Тогда
		
		Возврат НезаполненноеЗначение();
		
	ИначеЕсли Периодичность = ПлатежПоКонкретнойДате() Тогда
		
		Возврат ПреобразоватьДатуКСтроке(Период);
		
	КонецЕсли;
	
	// Для остальных нужен Год и НомерПериода
	Если (НомерПериода = Неопределено ИЛИ Год = Неопределено)
		И НЕ ЗначениеЗаполнено(Период) Тогда
		Возврат НезаполненноеЗначение();
	КонецЕсли;
	
	Если Год = Неопределено Тогда
		Год          = Год(Период);
	КонецЕсли;
	
	Если НомерПериода = Неопределено Тогда
		НомерПериода = 0;
		
		Если Периодичность = ПериодичностьКвартал() Тогда
			НомерПериода = (2 + Месяц(НачалоКвартала(Период))) / 3;
		ИначеЕсли Периодичность = ПериодичностьМесяц() Тогда
			НомерПериода = Месяц(Период);
		ИначеЕсли Периодичность = ПериодичностьПолугодие() Тогда
			Если Месяц(Период) <= 6 Тогда
				НомерПериода = 1;
			Иначе
				НомерПериода = 2;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Периодичность
		+ "." + Формат(НомерПериода, "ЧЦ=2; ЧН=; ЧВН=")
		+ "." + Формат(Год, "ЧЦ=4; ЧГ=");
	
	КонецФункции
	
Функция ПреобразоватьДатуКСтроке(Дата) Экспорт
	
	Если ТипЗнч(Дата) = Тип("Дата") И ЗначениеЗаполнено(Дата) Тогда
		Возврат Формат(Дата, "ДФ=dd.MM.yyyy");
	Иначе
		Возврат НезаполненноеЗначение();
	КонецЕсли;
	
КонецФункции

Функция МаксимальноеЗначениеПоПериодичности(Периодичность)
	
	Результат = Неопределено;
	Если Периодичность = ПериодичностьМесяц() Тогда
		Результат = 12;
	ИначеЕсли Периодичность = ПериодичностьКвартал() Тогда
		Результат = 4;
	ИначеЕсли Периодичность = ПериодичностьПолугодие() Тогда
		Результат = 2;
	ИначеЕсли Периодичность = ПериодичностьГод() Тогда
		Результат = 1;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПредставлениеНалоговогоПериода(НалоговыйПериод) Экспорт
	
	ОписаниеПериода = РазобратьНалоговыйПериод(НалоговыйПериод);
	
	ПараметрыТекста = Новый Структура;
	ПараметрыТекста.Вставить("Год",          Формат(ОписаниеПериода.Год,  "ЧГ=0"));
	ПараметрыТекста.Вставить("НомерПериода", ОписаниеПериода.НомерПериода);
	
	Если ОписаниеПериода.Периодичность = ПлатежПоКонкретнойДате() Тогда
		Шаблон = НСтр("ru = 'по сроку уплаты [Дата]'");
		ПараметрыТекста.Вставить("Дата", Формат(ОписаниеПериода.Дата, "ДФ=dd.MM.yyyy"));
	ИначеЕсли ОписаниеПериода.Периодичность = ПериодичностьГод() Тогда
		Шаблон = НСтр("ru = 'за [Год] год'");
	ИначеЕсли ОписаниеПериода.Периодичность = ПериодичностьПолугодие() Тогда
		Шаблон = НСтр("ru = 'за [НомерПериода] полугодие [Год] года'");
	ИначеЕсли ОписаниеПериода.Периодичность = ПериодичностьКвартал() Тогда
		Шаблон = НСтр("ru = 'за [НомерПериода] квартал [Год] года'");
	ИначеЕсли ОписаниеПериода.Периодичность = ПериодичностьМесяц() Тогда
		Шаблон = НСтр("ru = 'за [ИмяМесяца] [Год] года'");
		ПараметрыТекста.Вставить("ИмяМесяца", Нрег(Формат(ОписаниеПериода.Дата, "ДФ=MMMM")));
	Иначе
		Шаблон = "";
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(Шаблон, ПараметрыТекста);
	
КонецФункции

Функция ДатаНачалаНалоговогоПериода(Периодичность, Год, НомерПериода)
	
	Если Год = 0 Тогда
		Возврат Дата(1, 1, 1);
	ИначеЕсли НомерПериода = 0 Тогда
		Возврат Дата(Год, 1, 1);
	ИначеЕсли Периодичность = ПериодичностьМесяц() Тогда
		Возврат Дата(Год, НомерПериода, 1);
	ИначеЕсли Периодичность = ПериодичностьКвартал() Тогда
		Возврат Дата(Год, НомерПериода * 3 - 2, 1);
	ИначеЕсли Периодичность = ПериодичностьПолугодие() Тогда
		Возврат Дата(Год, НомерПериода * 6 - 5, 1);
	Иначе
		Возврат Дата(Год, 1, 1);
	КонецЕсли;
	
КонецФункции

Функция РазобратьНалоговыйПериод(Знач НалоговыйПериод) Экспорт
	
	ОписаниеПериода = Новый Структура;
	ОписаниеПериода.Вставить("Периодичность", НезаполненноеЗначение());
	ОписаниеПериода.Вставить("Год",           0);
	ОписаниеПериода.Вставить("НомерПериода",  0);
	ОписаниеПериода.Вставить("Дата",          '0001-01-01');
	
	// Реквизит 107 заполняется налоговым периодом, который имеет 10 знаков, 
	// восемь из которых имеют смысловое значение, а два являются разделительными знаками и заполняются точками (".")
	
	Если СтрДлина(НалоговыйПериод) <> 10 Тогда
		Возврат ОписаниеПериода;
	КонецЕсли;
	
	ЧастиПериода = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(НалоговыйПериод, ".", Ложь);
	Если ЧастиПериода.Количество() <> 3 Тогда
		Возврат ОписаниеПериода;
	КонецЕсли;
	
	// Предусмотрены два варианта:
	// 1. Первые два знака налогового периода предназначены для определения периодичности уплаты
	// 2. Форматом "день.месяц.год" указывается конкретная дата (например: "05.09.2003")
	
	Если СтрДлина(ЧастиПериода[0]) <> 2 Тогда
		Возврат ОписаниеПериода;
	КонецЕсли;
	
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ЧастиПериода[1])
		ИЛИ НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ЧастиПериода[2]) Тогда
		Возврат ОписаниеПериода;
	КонецЕсли;
	
	Периодичность = ЧастиПериода[0];
	Если СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(Периодичность) Тогда
		Периодичность = ПлатежПоКонкретнойДате();
	ИначеЕсли ВидыНалоговыхПериодов().НайтиПоЗначению(Периодичность) = Неопределено Тогда
		Возврат ОписаниеПериода;
	КонецЕсли;
	
	Если Периодичность = ПлатежПоКонкретнойДате() Тогда
		Попытка
			Значение = Дата(ЧастиПериода[2], ЧастиПериода[1], ЧастиПериода[0]);
		Исключение
			Значение = Неопределено;
		КонецПопытки;
		Если Значение = Неопределено Тогда
			Возврат ОписаниеПериода;
		Иначе
			ОписаниеПериода.Дата = Значение;
			ОписаниеПериода.Год  = Год(Значение);
		КонецЕсли;
	Иначе
		Попытка
			НомерПериода = Число(ЧастиПериода[1]);
			Год          = Число(ЧастиПериода[2]);
		Исключение
			НомерПериода = 0;
			Год          = 0;
		КонецПопытки;
		Если Год = 0 Тогда
			Возврат ОписаниеПериода;
		Иначе
			МаксимальноеЗначениеПоПериодичности = МаксимальноеЗначениеПоПериодичности(Периодичность);
			Если МаксимальноеЗначениеПоПериодичности = Неопределено ИЛИ НомерПериода > МаксимальноеЗначениеПоПериодичности Тогда
				Возврат ОписаниеПериода;
			КонецЕсли;
			
			ОписаниеПериода.НомерПериода = НомерПериода;
			ОписаниеПериода.Год          = Год;
			ОписаниеПериода.Дата         = ДатаНачалаНалоговогоПериода(Периодичность, Год, НомерПериода);
		КонецЕсли;
	КонецЕсли;
	
	ОписаниеПериода.Периодичность = Периодичность;
	Возврат ОписаниеПериода;
	
КонецФункции

// Возвращает список вариантов налоговых периодов
//
// Возвращаемое значение:
//  СписокЗначений – в котором создаются элементы с вариантами налоговых периодов
//
Функция ВидыНалоговыхПериодов() Экспорт
	
	// Первые два знака налогового периода предназначены для определения периодичности уплаты
	
	Периоды = Новый СписокЗначений;
	Периоды.Добавить(ПериодичностьМесяц(),     "МС - месячный платеж");
	Периоды.Добавить(ПериодичностьКвартал(),   "КВ - квартальный платеж");
	Периоды.Добавить(ПериодичностьПолугодие(), "ПЛ - полугодовой платеж");
	Периоды.Добавить(ПериодичностьГод(),       "ГД - годовой платеж"); 
	Периоды.Добавить(ПлатежПоКонкретнойДате(), "Платеж по конкретной дате");
	Периоды.Добавить(НезаполненноеЗначение(),  "0 - значение не указывается");
	
	Возврат Периоды;
	
КонецФункции
#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

Функция ОставитьВСтрокеТолькоЦифры(ИсходнаяСтрока) Экспорт
	
	СтрокаРезультат = "";
	
	Для а = 1 По СтрДлина(ИсходнаяСтрока) Цикл
		ТекущийСимвол = Сред(ИсходнаяСтрока, а, 1);
		КодСимвола = КодСимвола(ТекущийСимвол);
		Если КодСимвола >= 48 И КодСимвола <= 57 Тогда
			СтрокаРезультат = СтрокаРезультат + ТекущийСимвол;
		КонецЕсли;
	КонецЦикла;
	
	Возврат СтрокаРезультат;
	
КонецФункции

#КонецОбласти

