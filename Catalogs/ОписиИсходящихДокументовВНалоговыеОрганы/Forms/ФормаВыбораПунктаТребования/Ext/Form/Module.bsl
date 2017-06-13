﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	
	Если ЗначениеЗаполнено(Параметры.ТипПункта) Тогда
		ТипПункта = Параметры.ТипПункта;
	Иначе
		ТипПункта = "1";
	КонецЕсли;
	
	НомерПункта = Параметры.НомерПункта;
	НомерПунктаСтрока = НомерПунктаСтрокой(ТипПункта, НомерПункта);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеОтметкой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипПунктаПриИзменении(Элемент)
	
	НомерПунктаСтрока = НомерПунктаСтрокой(ТипПункта, НомерПункта);
	УправлениеОтметкой();

КонецПроцедуры

&НаКлиенте
Процедура НомерПунктаРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	НовоеЗначение = НомерПункта + Направление;
	Если НовоеЗначение >= 0 Тогда
		НомерПункта = НовоеЗначение;
    	НомерПунктаСтрока = НомерПунктаСтрокой(ТипПункта, НомерПункта);
	КонецЕсли;
	
	УправлениеОтметкой();
	
КонецПроцедуры

&НаКлиенте
Процедура НомерПунктаПриИзменении(Элемент)
	
	Если ПустаяСтрока(НомерПунктаСтрока) Тогда
		НомерПункта = 0;
	Иначе
		НомерПункта = Число(НомерПунктаСтрока);
	КонецЕсли;
	
	НомерПунктаСтрока = НомерПунктаСтрокой(ТипПункта, НомерПункта);
	
	УправлениеОтметкой();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НажатиеОК(Команда)
	
	Если НомерПункта = 0 И ТипПункта = "1" Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Не заполнено поле ""Номер""'"));
		Возврат;
	КонецЕсли;

	ПунктТребования = ТипПункта + "." + НомерПунктаСтрока;
	Закрыть(ПунктТребования);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Функция НомерПунктаСтрокой(ТипПункта, НомерПункта)
	
	Если ТипПункта = "1" Тогда
		СтрокаФормата = "ЧЦ=2; ЧН='  '; ЧВН=";
	Иначе
		СтрокаФормата = "ЧЦ=2; ЧН='00'; ЧВН=";
	КонецЕсли;
	
	Возврат Формат(НомерПункта, СтрокаФормата);
	
КонецФункции

&НаКлиенте
Процедура УправлениеОтметкой()
	
	Если НомерПункта = 0 И ТипПункта = "1" Тогда
		Элементы.НомерПункта.ОтметкаНезаполненного = Истина;
	Иначе
		Элементы.НомерПункта.ОтметкаНезаполненного = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти



 