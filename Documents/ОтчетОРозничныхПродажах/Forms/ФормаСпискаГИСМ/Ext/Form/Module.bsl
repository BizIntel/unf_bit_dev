﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	
	// Обработчик подсистемы "Внешние обработки"
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	КассаККМЗаполнена = ЗначениеЗаполнено(КассаККМ);
	
	Элементы.ОтчетыОРозничныхПродажахСоздать.Доступность = НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена;
	Элементы.ОтчетыОРозничныхПродажахСкопировать.Доступность =  НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена;
	Элементы.КонтекстноеМенюОтчетыОРозничныхПродажахСоздать.Доступность = НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена;
	Элементы.КонтекстноеМенюОтчетыОРозничныхПродажахСкопировать.Доступность = НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена;
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать

	
	// ИнтеграцияГИСМ
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ОтчетыОРозничныхПродажах, "ЕстьМаркируемаяПродукцияГИСМ", Истина, ВидСравненияКомпоновкиДанных.Равно,, Истина);
	
	СтруктураБыстрогоОтбора = Неопределено;
	Параметры.Свойство("СтруктураБыстрогоОтбора", СтруктураБыстрогоОтбора);
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(ОтчетыОРозничныхПродажах, "СтатусГИСМ", СтатусГИСМ, СтруктураБыстрогоОтбора);
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(ОтчетыОРозничныхПродажах, "Ответственный", Ответственный, СтруктураБыстрогоОтбора);
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриСозданииНаСервере(ОтчетыОРозничныхПродажах, "Организация", Организация, СтруктураБыстрогоОтбора);

	Если ИнтеграцияГИСМКлиентСервер.НеобходимОтборПоДальнейшемуДействиюГИСМПриСозданииНаСервере(ДальнейшееДействиеГИСМ, СтруктураБыстрогоОтбора) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	ИнтеграцияГИСМ.ЗаполнитьСписокВыбораДальнейшееДействие(
		Элементы.ДальнейшееДействиеГИСМОтбор.СписокВыбора,
		ИнтеграцияГИСМ.ВсеТребующиеДействияСтатусыИнформирования(), 
		ИнтеграцияГИСМ.ВсеТребующиеОжиданияСтатусыИнформирования());
	// Конец ИнтеграцияГИСМ

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_ОтчетОРозничныхПродажах" Тогда
		
		Элементы.ОтчетыОРозничныхПродажах.Обновить();
		
	КонецЕсли;
	
	// ИнтеграцияГИСМ
	Если ИмяСобытия = "ИзменениеСостоянияГИСМ"
		И ТипЗнч(Параметр.Ссылка) = Тип("ДокументСсылка.ОтчетОРозничныхПродажах") Тогда
		
		Элементы.ОтчетыОРозничныхПродажах.Обновить();
		
	КонецЕсли;
	
	Если ИмяСобытия = "ВыполненОбменГИСМ"
		И (Параметр = Неопределено
		Или (ТипЗнч(Параметр) = Тип("Структура") И Параметр.ОбновлятьСтатусГИСМФормахВДокументах)) Тогда
		
		Элементы.ОтчетыОРозничныхПродажах.Обновить();
		
	КонецЕсли;
	// Конец ИнтеграцияГИСМ
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	КассаККМ = Настройки.Получить("КассаККМ");
	УстановитьОтборДинамическихСписков();
	
	ЗапрещеноДобавлятьНовыеДокументы = ЗапрещеноДобавлятьНовыеДокументы(КассаККМ);
	
	КассаККМЗаполнена = ЗначениеЗаполнено(КассаККМ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КассаОтборПриИзменении(Элемент)
	
	УстановитьОтборДинамическихСписковНаКлиенте();
	УстановитьДоступностьКнопокСозданияНовыхДокументов();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыОтчетыорозничныхпродажах

&НаКлиенте
Процедура ОтчетыОРозничныхПродажахПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	КассаККМЗаполнена = ЗначениеЗаполнено(КассаККМ);
	
	Если Не(Не ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена) Тогда
		Отказ = Истина;	
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы


// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.ОтчетыОРозничныхПродажах);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#Область СлужебныеПроцедурыИФункции


#Область Прочее


// Процедура устанавливает отбор динамических списков формы.
//
&НаСервере
Процедура УстановитьОтборДинамическихСписков()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ОтчетыОРозничныхПродажах, 
		"КассаККМ",
		КассаККМ,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(КассаККМ));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ОтчетыОРозничныхПродажах,
		"СтатусГИСМ",
		СтатусГИСМ,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(СтатусГИСМ));
	
КонецПроцедуры

// Процедура устанавливает отбор динамических списков формы.
//
&НаКлиенте
Процедура УстановитьОтборДинамическихСписковНаКлиенте()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ОтчетыОРозничныхПродажах, "КассаККМ", КассаККМ, ВидСравненияКомпоновкиДанных.Равно,, ЗначениеЗаполнено(КассаККМ));
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойДанныхИзНастроекНаСервере(Настройки)
	
	КассаККМ = Настройки.Получить("КассаККМ");
	УстановитьОтборДинамическихСписков();
	
	ЗапрещеноДобавлятьНовыеДокументы = ЗапрещеноДобавлятьНовыеДокументы(КассаККМ);
	
	КассаККМЗаполнена = ЗначениеЗаполнено(КассаККМ);
	
	Элементы.ОтчетыОРозничныхПродажахСоздать.Доступность = НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена;
	Элементы.ОтчетыОРозничныхПродажахСкопировать.Доступность = НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена;
	Элементы.КонтекстноеМенюОтчетыОРозничныхПродажахСоздать.Доступность = НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена;
	Элементы.КонтекстноеМенюОтчетыОРозничныхПродажахСкопировать.Доступность = НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена;
	
	// ИнтеграцияГИСМ
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(ОтчетыОРозничныхПродажах,
	                                                                     "СтатусГИСМ",
	                                                                     СтатусГИСМ,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);
	
	Если ИнтеграцияГИСМКлиентСервер.НеобходимОтборПоДальнейшемуДействиюГИСМПередЗагрузкойИзНастроек(ДальнейшееДействиеГИСМ, СтруктураБыстрогоОтбора, Настройки) Тогда
		УстановитьОтборПоДальнейшемуДействиюСервер();
	КонецЕсли;
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(ОтчетыОРозничныхПродажах,
	                                                                     "Ответственный",
	                                                                     Ответственный,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);
	
	ИнтеграцияГИСМКлиентСервер.ОтборПоЗначениюСпискаПриЗагрузкеИзНастроек(ОтчетыОРозничныхПродажах,
	                                                                     "Организация",
	                                                                     Организация,
	                                                                     СтруктураБыстрогоОтбора,
	                                                                     Настройки);
	// Конец ИнтеграцияГИСМ
	
КонецПроцедуры

// ИнтеграцияГИСМ
&НаКлиенте
Процедура СтатусГИСМОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ОтчетыОРозничныхПродажах,
		"СтатусГИСМ",
		СтатусГИСМ,
		ВидСравненияКомпоновкиДанных.Равно,,
		ЗначениеЗаполнено(СтатусГИСМ));
	
КонецПроцедуры

&НаКлиенте
Процедура ДальнейшееДействиеГИСМОтборПриИзменении(Элемент)
	
	УстановитьОтборПоДальнейшемуДействиюСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура ОтветственныйОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		ОтчетыОРозничныхПродажах,
		"Ответственный",
		Ответственный,
		ВидСравненияКомпоновкиДанных.Равно,
		,
		ЗначениеЗаполнено(Ответственный));
		
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияОтборПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ОтчетыОРозничныхПродажах,
	                                                                        "Организация",
	                                                                        Организация,
	                                                                        ВидСравненияКомпоновкиДанных.Равно,
	                                                                        ,
	                                                                        ЗначениеЗаполнено(Организация));
	
КонецПроцедуры

// Конец ИнтеграцияГИСМ

&НаКлиенте
Процедура ОтчетыОРозничныхПродажахВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ДальнейшееДействиеГИСМ Тогда
		
		СтандартнаяОбработка = Ложь;
		ТекущиеДанные = Элемент.ДанныеСтроки(ВыбраннаяСтрока);
		
		ИнтеграцияГИСМКлиент.ВыполнитьДальнейшееДействиеДляДокументовИзСписка(
			Элементы.ОтчетыОРозничныхПродажах,
			Элемент.ДанныеСтроки(ВыбраннаяСтрока).ДальнейшееДействиеГИСМ);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередатьДанные(Команда)
	
	ИнтеграцияГИСМКлиент.ВыполнитьДальнейшееДействиеДляДокументовИзСписка(
		Элементы.ОтчетыОРозничныхПродажах,
		ПредопределенноеЗначение("Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные"));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбмен(Команда)
	
	ИнтеграцияГИСМКлиент.ВыполнитьОбмен();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Условное оформление динамического списка "СписокРаспоряженияНаОформление"
	СписокУсловноеОформление = ОтчетыОРозничныхПродажах.КомпоновщикНастроек.Настройки.УсловноеОформление;
	СписокУсловноеОформление.Элементы.Очистить();
	
	// ИнтеграцияГИСМ
	ИнтеграцияГИСМ.УстановитьУсловноеОформлениеСтатусДальнейшееДействиеГИСМ(
		СписокУсловноеОформление,
		Элементы,
		Элементы.СтатусГИСМ.Имя,
		Элементы.ДальнейшееДействиеГИСМ.Имя,
		"СтатусГИСМ",
		"ДальнейшееДействиеГИСМ");
		
	ИнтеграцияГИСМ.УстановитьУсловноеОформлениеСтатусИнформированияГИСМ(
		СписокУсловноеОформление,
		Элементы,
		Элементы.СтатусГИСМ.Имя,
		"СтатусГИСМ");
	// Конец ИнтеграцияГИСМ

КонецПроцедуры
&НаСервереБезКонтекста
Функция ЗапрещеноДобавлятьНовыеДокументы(КассаККМ)
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(КассаККМ, "ТипКассы");
	Возврат Реквизиты.ТипКассы = Перечисления.ТипыКассККМ.ФискальныйРегистратор
	    ИЛИ Реквизиты.ТипКассы = Перечисления.ТипыКассККМ.ККМOffline;
	
КонецФункции

// Так же вызывается ПриЗагрузкеДанныхИзНастроекНаСервере
&НаКлиенте
Процедура УстановитьДоступностьКнопокСозданияНовыхДокументов()
	
	ЗапрещеноДобавлятьНовыеДокументы = ЗапрещеноДобавлятьНовыеДокументы(КассаККМ);
	
	КассаККМЗаполнена = ЗначениеЗаполнено(КассаККМ);
	
	Элементы.ОтчетыОРозничныхПродажахСоздать.Доступность = НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена;
	Элементы.ОтчетыОРозничныхПродажахСкопировать.Доступность = НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена;
	Элементы.КонтекстноеМенюОтчетыОРозничныхПродажахСоздать.Доступность = НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена;
	Элементы.КонтекстноеМенюОтчетыОРозничныхПродажахСкопировать.Доступность = НЕ ЗапрещеноДобавлятьНовыеДокументы И КассаККМЗаполнена;
	
КонецПроцедуры


// ИнтеграцияГИСМ
#Область ОтборДальнейшиеДействия

&НаСервере
Процедура УстановитьОтборПоДальнейшемуДействиюСервер()
	
	ИнтеграцияГИСМ.УстановитьОтборПоДальнейшемуДействию(ОтчетыОРозничныхПродажах,
	                                                    ДальнейшееДействиеГИСМ,
	                                                    ИнтеграцияГИСМ.ВсеТребующиеДействияСтатусыИнформирования(), 
	                                                    ИнтеграцияГИСМ.ВсеТребующиеОжиданияСтатусыИнформирования());
	
КонецПроцедуры

#КонецОбласти
// Конец ИнтеграцияГИСМ

#КонецОбласти

#КонецОбласти
