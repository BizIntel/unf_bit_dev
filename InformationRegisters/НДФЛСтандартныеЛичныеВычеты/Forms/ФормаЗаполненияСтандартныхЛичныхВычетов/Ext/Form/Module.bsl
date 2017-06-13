﻿///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРЫБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗапись();
	Элементы.ГруппаКодВычета.Доступность = Запись.Применяется;
	
КонецПроцедуры


&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	СохранитьЗапись();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	
	СохранитьЗапись();
	
КонецПроцедуры

&НаКлиенте
Процедура ПрименяетсяПриИзменении(Элемент)
	
	Элементы.ГруппаКодВычета.Доступность = Запись.Применяется;

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПодробнееКод104(Команда)
	
	РегламентированнаяОтчетностьУСНКлиент.ПоказатьОписаниеВычетаНДФЛ("104");
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПодробнееКод105(Команда)
	
	РегламентированнаяОтчетностьУСНКлиент.ПоказатьОписаниеВычетаНДФЛ("105");
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ
&НаСервере
Процедура ЗаполнитьЗапись()
	
	ЗапросПоЛичномуВычету = Новый Запрос;
	ЗапросПоЛичномуВычету.Текст =
	"ВЫБРАТЬ
	|	НДФЛСтандартныеЛичныеВычетыСрезПоследних.Период,
	|	НДФЛСтандартныеЛичныеВычетыСрезПоследних.Сотрудник,
	|	НДФЛСтандартныеЛичныеВычетыСрезПоследних.Применяется,
	|	НДФЛСтандартныеЛичныеВычетыСрезПоследних.КодВычета,
	|	НДФЛСтандартныеЛичныеВычетыСрезПоследних.Представление
	|ИЗ
	|	РегистрСведений.НДФЛСтандартныеЛичныеВычеты.СрезПоследних КАК НДФЛСтандартныеЛичныеВычетыСрезПоследних
	|ГДЕ
	|	НДФЛСтандартныеЛичныеВычетыСрезПоследних.Сотрудник = &Сотрудник";
	ЗапросПоЛичномуВычету.УстановитьПараметр("Сотрудник", Параметры.Сотрудник);
	Выборка = ЗапросПоЛичномуВычету.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ЗаполнитьЗначенияСвойств(Запись, Выборка);
	Иначе
		Запись.Сотрудник = Параметры.Сотрудник;
	КонецЕсли;
	
КонецПроцедуры


// Процедура сохраняет запись в регистр сведений ДокументыФизическихЛиц
&НаСервере
Процедура СохранитьЗапись()
	
	МенеджерЗаписи = РегистрыСведений.НДФЛСтандартныеЛичныеВычеты.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(МенеджерЗаписи, Запись);
	МенеджерЗаписи.Записать();
	Модифицированность = Ложь;
	
КонецПроцедуры


