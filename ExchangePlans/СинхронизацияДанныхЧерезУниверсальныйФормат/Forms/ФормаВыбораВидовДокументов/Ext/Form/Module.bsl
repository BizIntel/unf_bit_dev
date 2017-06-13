﻿////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ВидыДокументов") Тогда
		ВидыДокументов = Параметры.ВидыДокументов;
	Иначе
		ВидыДокументов = Новый Массив;
	КонецЕсли;
	
	СформироватьДеревоВидовДокументов(ВидыДокументов);
	Элементы.ОтборПоВидамДокументов.НачальноеОтображениеДерева = НачальноеОтображениеДерева.РаскрыватьВсеУровни;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЦЫ ОтборПоВидамДокументов ФОРМЫ

&НаСервере
Процедура ДобавитьСтрокуДереваВидовДокументов(ОбъектМетаданных, СтрокаВерхнегоУровня)

	СтрокаДетальныеЗаписи = СтрокаВерхнегоУровня.Строки.Добавить();
	СтрокаДетальныеЗаписи.ИмяОбъектаМетаданных = ОбъектМетаданных.Имя;
	СтрокаДетальныеЗаписи.ПолноеИмяМетаданных = ОбъектМетаданных.ПолноеИмя();
	СтрокаДетальныеЗаписи.Представление = ОбъектМетаданных.Синоним;

КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоВидовДокументов(МассивВыбранныхЗначений)

	ДеревоОтбора = РеквизитФормыВЗначение("ДеревоОтбораПоВидамДокументов", Тип("ДеревоЗначений"));
	ДеревоОтбора.Строки.Очистить();
	
	МетаДокументы = Метаданные.Документы;
	
	СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
	СтрокаВерхнегоУровня.Представление = "Продажи";
	
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.АктВыполненныхРабот, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.РасходнаяНакладная, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.КорректировкаРеализации, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СчетНаОплату, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СчетФактура, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ОтчетКомиссионера, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ОтчетОРозничныхПродажах, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПереоценкаВРозницеСуммовойУчет, СтрокаВерхнегоУровня);
	
	СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
	СтрокаВерхнегоУровня.Представление = "Закупки";
	
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПриходнаяНакладная, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ДополнительныеРасходы, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.РасходыПриИмпорте, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.КорректировкаПоступления, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СчетНаОплатуПоставщика, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ОтчетКомитенту, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ОтчетПереработчика, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПеремещениеЗапасов, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ИнвентаризацияЗапасов, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ОприходованиеЗапасов, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СписаниеЗапасов, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СчетФактураПолученный, СтрокаВерхнегоУровня);
	
	СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
	СтрокаВерхнегоУровня.Представление = "Сервис";
	
	СтрокаДетальныеЗаписи = СтрокаВерхнегоУровня.Строки.Добавить();
	СтрокаДетальныеЗаписи.ИмяОбъектаМетаданных = МетаДокументы.ЗаказПокупателя.Имя;
	СтрокаДетальныеЗаписи.ПолноеИмяМетаданных = МетаДокументы.ЗаказПокупателя.ПолноеИмя();
	СтрокаДетальныеЗаписи.Представление = "Заказ-наряд";
	
	СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
	СтрокаВерхнегоУровня.Представление = "Производство";
	
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.СборкаЗапасов, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПеремещениеЗапасов, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ОтчетОПереработке, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.РаспределениеЗатрат, СтрокаВерхнегоУровня);
	
	СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
	СтрокаВерхнегоУровня.Представление = "Деньги";
	
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.АвансовыйОтчет, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПоступлениеВКассу, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПоступлениеНаСчет, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.РасходИзКассы, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.РасходСоСчета, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ОперацияПоПлатежнымКартам, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПеремещениеДС, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПлатежноеПоручение, СтрокаВерхнегоУровня);
	
	СтрокаВерхнегоУровня = ДеревоОтбора.Строки.Добавить();
	СтрокаВерхнегоУровня.Представление = "Прочее";
	
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.Взаимозачет, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ДоговорКредитаИЗайма, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.НачисленияПоКредитамИЗаймам, СтрокаВерхнегоУровня);
	ДобавитьСтрокуДереваВидовДокументов(МетаДокументы.ПрочиеРасходы, СтрокаВерхнегоУровня);
	
	Для каждого СтрокаВерхнегоУровня Из ДеревоОтбора.Строки Цикл
		ВыбраныВсеЭлементы = Истина;
		Для каждого СтрокаДетальныеЗаписи Из СтрокаВерхнегоУровня.Строки Цикл
			Если МассивВыбранныхЗначений.Найти(СтрокаДетальныеЗаписи.ИмяОбъектаМетаданных) = Неопределено Тогда
				ВыбраныВсеЭлементы = Ложь;
			Иначе
				СтрокаДетальныеЗаписи.Пометка = Истина;
			КонецЕсли;
			СтрокаДетальныеЗаписи.ИндексКартинки = -1;
		КонецЦикла;
		Если ВыбраныВсеЭлементы Тогда
			СтрокаВерхнегоУровня.Пометка = Истина;
		КонецЕсли;
		СтрокаВерхнегоУровня.ИндексКартинки = 0;
	КонецЦикла;
	
	ЗначениеВРеквизитФормы(ДеревоОтбора, "ДеревоОтбораПоВидамДокументов");
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметку(Команда)
	
	ЗаполнитьОтметки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтметитьВсе(Команда)
	
	ЗаполнитьОтметки(Истина);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьОтметки(ЗначениеОтметки, ИдентификаторЭлемента = Неопределено)
	Если ИдентификаторЭлемента <> Неопределено Тогда
		ЭлементДерева = ДеревоОтбораПоВидамДокументов.НайтиПоИдентификатору(ИдентификаторЭлемента);
		ЭлементыНижнегоУровня = ЭлементДерева.ПолучитьЭлементы();
		Для Каждого ЭлементНижнегоУровня Из ЭлементыНижнегоУровня Цикл
			ЭлементНижнегоУровня.Пометка = ЗначениеОтметки;
		КонецЦикла;
	Иначе
		ЭлементыВерхнегоУровня = ДеревоОтбораПоВидамДокументов.ПолучитьЭлементы();
		Для Каждого ЭлементВерхнегоУровня Из ЭлементыВерхнегоУровня Цикл
			ЭлементВерхнегоУровня.Пометка = ЗначениеОтметки;
			ЭлементыНижнегоУровня = ЭлементВерхнегоУровня.ПолучитьЭлементы();
			Для каждого ЭлементНижнегоУровня Из ЭлементыНижнегоУровня Цикл
				ЭлементНижнегоУровня.Пометка = ЗначениеОтметки;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПоВидамДокументовПометкаПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ОтборПоВидамДокументов.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		
		ЗначениеОтметки = ТекущиеДанные.Пометка;
		Если ТекущиеДанные.ПолучитьРодителя() = Неопределено Тогда
			ЗаполнитьОтметки(ЗначениеОтметки, ТекущиеДанные.ПолучитьИдентификатор());
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьЗакрыть(Команда)
	
	ПараметрыЗакрытияФормы = Новый Структура();
	ПараметрыЗакрытияФормы.Вставить("АдресТаблицыВоВременномХранилище", СформироватьТаблицуВыбранныхЗначений());
	ПараметрыЗакрытияФормы.Вставить("ИмяТаблицыДляЗаполнения",          "ВидыДокументов");
	
	ОповеститьОВыборе(ПараметрыЗакрытияФормы);
	
КонецПроцедуры

&НаСервере
Функция СформироватьТаблицуВыбранныхЗначений()

	ТаблицаВыбранныхЗначений = Новый ТаблицаЗначений;
	ТаблицаВыбранныхЗначений.Колонки.Добавить("ИмяОбъектаМетаданных");
	ТаблицаВыбранныхЗначений.Колонки.Добавить("Представление");
	ТаблицаВыбранныхЗначений.Колонки.Добавить("Использовать");
	
	ЭлементыВерхнегоУровня = ДеревоОтбораПоВидамДокументов.ПолучитьЭлементы();
	Для каждого ЭлементВерхнегоУровня Из ЭлементыВерхнегоУровня Цикл
		ЭлементыДетальныхЗаписей = ЭлементВерхнегоУровня.ПолучитьЭлементы();
		Для каждого ЭлементДетальныхЗаписей Из ЭлементыДетальныхЗаписей Цикл
			Если Не ЭлементДетальныхЗаписей.Пометка Тогда
				Продолжить;
			КонецЕсли;
			НоваяСтрока = ТаблицаВыбранныхЗначений.Добавить();
			НоваяСтрока.ИмяОбъектаМетаданных = ЭлементДетальныхЗаписей.ИмяОбъектаМетаданных;
			НоваяСтрока.Представление = ЭлементДетальныхЗаписей.Представление;
			НоваяСтрока.Использовать = Истина;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ПоместитьВоВременноеХранилище(ТаблицаВыбранныхЗначений, УникальныйИдентификатор);

КонецФункции

