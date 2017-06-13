﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Дата = КонецКвартала(ТекущаяДатаСеанса());
		Объект.ВидЗаписей = Перечисления.ВидыЗаписейФормированийКУДиР.РучныеЗаписи;
		ДокументыЗаПериод = Параметры.ДокументыЗаПериод;
		Если Параметры.Свойство("Организация") и ЗначениеЗаполнено(Параметры.Организация) Тогда
			Объект.Организация = Параметры.Организация;
		КонецЕсли;
	КонецЕсли;
	
	Если Объект.ВидЗаписей = Перечисления.ВидыЗаписейФормированийКУДиР.РучныеЗаписи Тогда
		Элементы.ГруппаПредупреждения.Видимость = Ложь;
	Иначе
		ТолькоПросмотр = Истина;
	КонецЕсли;
	НомерСтроки = Параметры.НомерСтроки;
	Если Объект.ЗаписиКУДиР.Количество() > 0 Тогда
		РабочаяСтрока = Объект.ЗаписиКУДиР[НомерСтроки-1];
		ДоходыВсего = РабочаяСтрока.ДоходВсего;
		Доходы = РабочаяСтрока.ДоходБаза;
		РасходыВсего = РабочаяСтрока.РасходВсего;
		Расходы = РабочаяСтрока.РасходБаза;
		ДатаПервичногоДокумента = РабочаяСтрока.ДатаПервичногоДокумента;
		НомерПервичногоДокумента = РабочаяСтрока.НомерПервичногоДокумента;
		Содержание = РабочаяСтрока.Содержание;
		ПервичныйДокумент = РабочаяСтрока.ПервичныйДокумент;
	КонецЕсли;
	
	Элементы.ПервичныйДокумент.Видимость = ЗначениеЗаполнено(ПервичныйДокумент);
	
	
	УстановитьВидимостьИДоступностьЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Если Объект.ВидЗаписей = Перечисления.ВидыЗаписейФормированийКУДиР.РучныеЗаписи Тогда
		ПроверяемыеРеквизиты.Добавить("НомерПервичногоДокумента");
		ПроверяемыеРеквизиты.Добавить("ДатаПервичногоДокумента");
		ПроверяемыеРеквизиты.Добавить("Содержание");
	КонецЕсли;
КонецПроцедуры



&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если Объект.Ссылка.Пустая() Тогда
		
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.ВидЗаписей = Перечисления.ВидыЗаписейФормированийКУДиР.РучныеЗаписи Тогда
		// сохраняем ручные данные первой строки
		ТекущийОбъект.Дата = КонецКвартала(ДатаПервичногоДокумента);
		ТекущийОбъект.ЗаписиКУДиР.Очистить();
		РабочаяСтрока = ТекущийОбъект.ЗаписиКУДиР.Добавить();
		РабочаяСтрока.ДоходВсего = ДоходыВсего;
		РабочаяСтрока.ДоходБаза = Доходы;
		РабочаяСтрока.РасходВсего = РасходыВсего;
		РабочаяСтрока.РасходБаза = Расходы;
		РабочаяСтрока.ДатаПервичногоДокумента = ДатаПервичногоДокумента;
		РабочаяСтрока.НомерПервичногоДокумента = НомерПервичногоДокумента;
		РабочаяСтрока.Содержание = Содержание;
	Иначе
		Если ТекущийОбъект.ЗаписиКУДиР.Количество() > 0 Тогда
			РабочаяСтрока = ТекущийОбъект.ЗаписиКУДиР[НомерСтроки-1];
			РабочаяСтрока.ДоходВсего = ДоходыВсего;
			РабочаяСтрока.ДоходБаза = Доходы;
			РабочаяСтрока.РасходВсего = РасходыВсего;
			РабочаяСтрока.РасходБаза = Расходы;
			РабочаяСтрока.ДатаПервичногоДокумента = ДатаПервичногоДокумента;
			РабочаяСтрока.НомерПервичногоДокумента = НомерПервичногоДокумента;
			РабочаяСтрока.Содержание = Содержание;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМ


&НаКлиенте
Процедура ВключитьФормуДляРедактирования(Команда)
	
	ТолькоПросмотр = Ложь;
	Элементы.ГруппаПредупреждения.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ДоходыПриИзменении(Элемент)
	ДоходыВсего = Доходы;
КонецПроцедуры

&НаКлиенте
Процедура РасходыПриИзменении(Элемент)
	РасходыВсего = Расходы; 
КонецПроцедуры

&НаКлиенте
Процедура ПервичныйДокументНажатие(Элемент, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ПервичныйДокумент) Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(,ПервичныйДокумент);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура УстановитьВидимостьИДоступностьЭлементов() 
	
	Элементы.ГруппаРежимы.ТекущаяСтраница = Элементы.ГруппаРучная;
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЗапись(Команда)
	
	Если НомерСтроки <> 0 Тогда
		УдалитьЗаписьСервер();
		Оповестить("ИзмененыЗаписиКУДИР");
	КонецЕсли;
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьЗаписьСервер()
	
	РабочаяСтрока = Объект.ЗаписиКУДиР[НомерСтроки-1];
	Объект.ЗаписиКУДиР.Удалить(РабочаяСтрока);
	мОбъект = РеквизитФормыВЗначение("Объект");
	мОбъект.Записать(РежимЗаписиДокумента.Проведение);
	
КонецПроцедуры