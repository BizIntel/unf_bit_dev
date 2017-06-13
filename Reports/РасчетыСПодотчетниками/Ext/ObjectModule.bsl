﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиВариантов["ВедомостьВВалюте"].Рекомендуемый = Истина;
	
	ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов);
	УстановитьТегиВариантов(НастройкиВариантов);
	ДобавитьОписанияСвязанныхПолей(НастройкиВариантов);
	
КонецПроцедуры

Процедура ПриКонтекстномОткрытии(Объект, ПолеСвязи, Отборы, Отказ) Экспорт
	
	Если ПолеСвязи = "Сотрудник" Тогда
		Отборы.Вставить(ПолеСвязи, МассивСотрудников(Объект));
		Отборы.Вставить("СтПериод", Новый СтандартныйПериод);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ОтчетыУНФ.ПриКомпоновкеРезультата(КомпоновщикНастроек, СхемаКомпоновкиДанных, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов)
	
	МассивПолейСумм = Новый Массив;
	Для Каждого ДоступноеПоле Из КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы Цикл
		Если Не ДоступноеПоле.Ресурс Тогда
			Продолжить;
		КонецЕсли;
		МассивПолейСумм.Добавить(Строка(ДоступноеПоле.Поле));
	КонецЦикла;
	
	Для Каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		ВариантыОформления = НастройкиТекВарианта.Значение.ВариантыОформления;
		ОтчетыУНФ.ДобавитьВариантыОформленияСумм(ВариантыОформления, МассивПолейСумм);
	КонецЦикла;
	
КонецПроцедуры

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	Для Каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		НастройкиТекВарианта.Значение.Теги = НСтр("ru = 'Деньги,Персонал'");
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["ВедомостьВВалюте"].СвязанныеПоля, "Сотрудник", "Справочник.Сотрудники");
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["ВедомостьВВалюте"].СвязанныеПоля, "Сотрудник", "Документ.РасходСоСчета", Перечисления.ВидыОперацийРасходСоСчета.Подотчетнику, Истина, Истина);
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["ВедомостьВВалюте"].СвязанныеПоля, "Сотрудник", "Документ.АвансовыйОтчет",, Истина, Истина);
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["ВедомостьВВалюте"].СвязанныеПоля, "Сотрудник", "Документ.ПоступлениеВКассу", Перечисления.ВидыОперацийПоступлениеВКассу.ОтПодотчетника, Истина, Истина);
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["ВедомостьВВалюте"].СвязанныеПоля, "Сотрудник", "Документ.РасходИзКассы", Перечисления.ВидыОперацийРасходИзКассы.Подотчетнику, Истина, Истина);
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["ВедомостьВВалюте"].СвязанныеПоля, "Сотрудник", "Документ.ПоступлениеНаСчет", Перечисления.ВидыОперацийПоступлениеНаСчет.ОтПодотчетника, Истина, Истина);
	
КонецПроцедуры

Функция МассивСотрудников(ПараметрКоманды)
	
	Результат = Новый Массив;
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		МассивДокументов = ПараметрКоманды;
	Иначе
		МассивДокументов = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ПараметрКоманды);
	КонецЕсли;
	
	Для каждого Документ Из МассивДокументов Цикл
		Если ТипЗнч(Документ) = Тип("ДокументСсылка.АвансовыйОтчет") Тогда
			Сотрудник = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, "Сотрудник");
			Результат.Добавить(Сотрудник);
		Иначе
			Подотчетник = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, "Подотчетник");
			Результат.Добавить(Подотчетник);
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

ЭтоОтчетУНФ = Истина;

#КонецЕсли
