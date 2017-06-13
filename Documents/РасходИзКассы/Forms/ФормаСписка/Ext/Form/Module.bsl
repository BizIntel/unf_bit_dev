﻿#Область ОбщегоНазначения

// Процедура дополняет список выбора видов операций.
//
&НаСервере
Процедура ЗаполнитьСписокВыбораВидовОпераций()
	
	СписокВидовОпераций = ДвиженияДенежныхСредствВызовСервера.ПолучитьСписокВидовОперацийРасходДСКасса();
	Элементы.ОтборВидОперации.СписокВыбора.ЗагрузитьЗначения(СписокВидовОпераций.ВыгрузитьЗначения());

КонецПроцедуры // ДополнитСписокВыбораВидовОпераций()

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИнформационныйЦентрСервер.ВывестиКонтекстныеСсылки(ЭтотОбъект, Элементы.ИнформационныеСсылки);
	
	ЗаполнитьСписокВыбораВидовОпераций();
	
	//УНФ.ОтборыСписка
	РаботаСОтборами.ВосстановитьНастройкиОтборов(ЭтотОбъект, Список);
	//Конец УНФ.ОтборыСписка
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	УправлениеНебольшойФирмойСервер.УстановитьОтображаниеПодменюПечати(Элементы.ПодменюПечать);
	
	// Установим формат для текущей даты: ДФ=Ч:мм
	УправлениеНебольшойФирмойСервер.УстановитьОформлениеКолонкиДата(Список);
	
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
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_НаборКонстант" Тогда
		ЗаполнитьСписокВыбораВидовОпераций();
	ИначеЕсли ИмяСобытия = "Запись_РасходИзКассы" Тогда
		Если Параметр.Свойство("УдалениеПомеченных") И Параметр.УдалениеПомеченных Тогда
			Возврат;
		КонецЕсли;
		
		Элементы.Список.ТекущаяСтрока = Параметр.Ссылка;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьПоШаблону(Команда)
	
	ЗаполнениеОбъектовУНФКлиент.ПоказатьВыборШаблонаДляСозданияДокументаИзСписка(Список, Элементы.Список.ТекущаяСтрока);
	
КонецПроцедуры

&НаКлиенте
Процедура ВедомостьПерейти(Команда)
	
	ОткрытьФорму("Отчет.ДенежныеСредства.Форма", Новый Структура("КлючВарианта, СформироватьПриОткрытии", "Ведомость", Истина));
	
КонецПроцедуры // ВедомостьПерейти()

#КонецОбласти

#Область ЗамерыПроизводительности

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "СозданиеФормыРасходИзКассы");
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ОткрытиеФормыРасходИзКассы");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// ТехнологияСервиса.ИнформационныйЦентр
&НаКлиенте
Процедура Подключаемый_НажатиеНаИнформационнуюСсылку(Элемент)
	
	ИнформационныйЦентрКлиент.НажатиеНаИнформационнуюСсылку(ЭтотОбъект, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_НажатиеНаСсылкуВсеИнформационныеСсылки(Элемент)
	
	ИнформационныйЦентрКлиент.НажатиеНаСсылкуВсеИнформационныеСсылки(ЭтотОбъект.ИмяФормы);
	
КонецПроцедуры
// Конец ТехнологияСервиса.ИнформационныйЦентр

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#Область МеткиОтборов

&НаСервере
Процедура УстановитьМеткуИОтборСписка(СписокДляОтбора, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения="")
	
	Если ПредставлениеЗначения="" Тогда
		ПредставлениеЗначения=Строка(ВыбранноеЗначение);
	КонецЕсли; 
	
	РаботаСОтборами.ПрикрепитьМеткуОтбора(ЭтотОбъект, ИмяПоляОтбораСписка, ГруппаРодительМетки, ВыбранноеЗначение, ПредставлениеЗначения, СписокДляОтбора);
	РаботаСОтборами.УстановитьОтборСписка(ЭтотОбъект, ЭтотОбъект[СписокДляОтбора], ИмяПоляОтбораСписка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_МеткаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	МеткаИД = Сред(Элемент.Имя, СтрДлина("Метка_")+1);
	
	ИмяРеквизитаСписка = "Список";
	УдалитьМеткуОтбора(МеткаИД, ИмяРеквизитаСписка);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьМеткуОтбора(МеткаИД, ИмяРеквизитаСписка)
	
	РаботаСОтборами.УдалитьМеткуОтбораСервер(ЭтотОбъект, ЭтотОбъект[ИмяРеквизитаСписка], МеткаИД);

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

#Область ОбработчикиСобытийЭлементовФормы

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ДИНАМИЧЕСКОГО СПИСКА

// Выбор значения отбора в поле отбора
&НаКлиенте
Процедура ОтборКонтрагентОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Список", "Контрагент", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОрганизацияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Список", "Организация", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВидОперацииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Список", "ВидОперации", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСчетИКассаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Список", "Касса", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВалютаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Список", "ВалютаДенежныхСредств", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборАвторОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(ВыбранноеЗначение) Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьМеткуИОтборСписка("Список", "Автор", Элемент.Родитель.Имя, ВыбранноеЗначение);
	ВыбранноеЗначение = Неопределено;
	
КонецПроцедуры

#КонецОбласти

#Область РасходИзКассы

// Обработчик команды "РасходПрочиеРачетыКасса" формы.
//
&НаКлиенте
Процедура РасходПрочиеРачетыКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "ПрочиеРасчеты", ДанныеМеток);
	
КонецПроцедуры

&НаКлиенте
Процедура РасходНаРасходыКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "НаРасходы", ДанныеМеток);
	
КонецПроцедуры

&НаКлиенте
Процедура РасходПоставщикуКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "Поставщику", ДанныеМеток);
	
КонецПроцедуры

&НаКлиенте
Процедура РасходЗарплатаПоВедомостиКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "Зарплата", ДанныеМеток);
	
КонецПроцедуры

&НаКлиенте
Процедура РасходЗарплатаСотрудникуКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "ЗарплатаСотруднику", ДанныеМеток);
	
КонецПроцедуры

&НаКлиенте
Процедура РасходПокупателюКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "Покупателю", ДанныеМеток);
	
КонецПроцедуры

&НаКлиенте
Процедура РасходВозвратКредитаКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "РасчетыПоКредитам", ДанныеМеток);
	
КонецПроцедуры

&НаКлиенте
Процедура РасходВыдачаЗаймаКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "ВыдачаЗаймаСотруднику", ДанныеМеток);
	
КонецПроцедуры

&НаКлиенте
Процедура РасходПрочееКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "Прочее", ДанныеМеток);
	
КонецПроцедуры

&НаКлиенте
Процедура РасходПодотчетникуКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "Подотчетнику", ДанныеМеток);
	
КонецПроцедуры

&НаКлиенте
Процедура РасходПеремещениеВКассуККМКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "ПеремещениеВКассуККМ", ДанныеМеток);
	
КонецПроцедуры

&НаКлиенте
Процедура РасходНалогиКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "Налоги", ДанныеМеток);
	
КонецПроцедуры

&НаКлиенте
Процедура РасходВзносНаличнымиВБанкКасса(Команда)
	
	ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "ВзносНаличнымиВБанк", ДанныеМеток);
	
КонецПроцедуры

#КонецОбласти
