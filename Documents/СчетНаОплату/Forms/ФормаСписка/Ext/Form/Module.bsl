﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Вызов из панели функций.
	
	Список.Параметры.УстановитьЗначениеПараметра("АкутальнаяДатаСеанса", НачалоДня(ТекущаяДатаСеанса()));
	
	//УНФ.ОтборыСписка
	РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список);
	//Конец УНФ.ОтборыСписка
	
	// Установим формат для текущей даты: ДФ=Ч:мм
	УправлениеНебольшойФирмойСервер.УстановитьОформлениеКолонкиДата(Список);
	
	// ЭДО
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСписка();
	ПараметрыПриСозданииНаСервере.Форма = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд = Элементы.ГруппаКомандыЭДО;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСписка(Отказ, СтандартнаяОбработка, ПараметрыПриСозданииНаСервере);
	// Конец ЭДО
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	УправлениеНебольшойФирмойСервер.УстановитьОтображаниеПодменюПечати(Элементы.ПодменюПечать);
	
	// УНФ.ПанельКонтактнойИнформации
	КонтактнаяИнформацияПанельУНФ.ПриСозданииНаСервере(ЭтотОбъект, "КонтактнаяИнформация");
	// Конец УНФ.ПанельКонтактнойИнформации
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// ЭДО
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭДО
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОповещениеОбИзмененииДолга" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
	// ЭДО
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = ЭтотОбъект;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "Список";
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец ЭДО
	
	// УНФ.ПанельКонтактнойИнформации
	Если КонтактнаяИнформацияПанельУНФКлиент.ОбрабатыватьОповещения(ЭтотОбъект, ИмяСобытия, Параметр) Тогда
		ОбновитьПанельКонтактнойИнформацииСервер();
	КонецЕсли;
	// Конец УНФ.ПанельКонтактнойИнформации
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если НЕ ЗавершениеРаботы Тогда
		//УНФ.ОтборыСписка
		СохранитьНастройкиОтборов();
		//Конец УНФ.ОтборыСписка
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	Если ТипЗнч(Элемент.ТекущаяСтрока) <> Тип("СтрокаГруппировкиДинамическогоСписка") Тогда
		
		КонтрагентАктивнойСтроки = ?(Элемент.ТекущиеДанные = Неопределено, Неопределено, Элемент.ТекущиеДанные.Контрагент);
		Если КонтрагентАктивнойСтроки <> ТекущийКонтрагент Тогда
		
			ТекущийКонтрагент = КонтрагентАктивнойСтроки;
			ПодключитьОбработчикОжидания("ОбработатьАктивизациюСтрокиСписка", 0.2, Истина);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Контрагент", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОплатаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("СтатусОплаты", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтветственныйОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Ответственный", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Организация", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Обрабатывает событие активизации строки списка документов.
//
&НаКлиенте
Процедура ОбработатьАктивизациюСтрокиСписка()
	
	ОбновитьПанельКонтактнойИнформацииСервер();

КонецПроцедуры

#КонецОбласти

#Область МеткиОтборов

&НаСервере
Процедура УстановитьМеткуИОтборСписка(ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения="")
	
	Если ПредставлениеЗначения="" Тогда
		ПредставлениеЗначения=Строка(ВыбранноеЗначение);
	КонецЕсли; 
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения);
	РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, Список, ИмяПоляОтбораСписка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_")+1);
	УдалитьМеткуОтбора(МеткаИД);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД)
	
	РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, Список, МеткаИД);

КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РаботаСОтборамиКлиент.ПредставлениеПериодаВыбратьПериод(ЭтотОбъект, "Список", "Дата");
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиОтборов()
	
	РаботаСОтборами.СохранитьНастройкиОтборов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьРазвернутьПанельОтборов(Элемент)
	
	НовоеЗначениеВидимость = НЕ Элементы.ФильтрыНастройкиИДопИнфо.Видимость;
	РаботаСОтборамиКлиент.СвернутьРазвернутьПанельОтборов(ЭтотОбъект, НовоеЗначениеВидимость);
		
КонецПроцедуры

#КонецОбласти

#Область ЗамерыПроизводительности

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "СозданиеФормы" + РаботаСФормойДокументаКлиентСервер.ПолучитьИмяФормыСтрокой(ЭтотОбъект.ИмяФормы));
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ОткрытиеФормы" + РаботаСФормойДокументаКлиентСервер.ПолучитьИмяФормыСтрокой(ЭтотОбъект.ИмяФормы));
	
КонецПроцедуры

#КонецОбласти

#Область ПанельКонтактнойИнформации

// УНФ.ПанельКонтактнойИнформации
&НаСервере
Процедура ОбновитьПанельКонтактнойИнформацииСервер()
	
	КонтактнаяИнформацияПанельУНФ.ОбновитьДанныеПанели(ЭтотОбъект, ТекущийКонтрагент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	КонтактнаяИнформацияПанельУНФКлиент.ДанныеПанелиКонтактнойИнформацииВыбор(ЭтотОбъект, Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииПриАктивизацииСтроки(Элемент)
	
	КонтактнаяИнформацияПанельУНФКлиент.ДанныеПанелиКонтактнойИнформацииПриАктивизацииСтроки(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ДанныеПанелиКонтактнойИнформацииВыполнитьКоманду(Команда)
	
	КонтактнаяИнформацияПанельУНФКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда);
	
КонецПроцедуры
// Конец УНФ.ПанельКонтактнойИнформации

#КонецОбласти

#Область ОбработчикиБиблиотек

// ЭДО
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеСлужебныйКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры
// Конец ЭДО

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПоШаблону(Команда)
	
	ЗаполнениеОбъектовУНФКлиент.ПоказатьВыборШаблонаДляСозданияДокументаИзСписка(Список, Элементы.Список.ТекущаяСтрока);
	
КонецПроцедуры

#КонецОбласти

