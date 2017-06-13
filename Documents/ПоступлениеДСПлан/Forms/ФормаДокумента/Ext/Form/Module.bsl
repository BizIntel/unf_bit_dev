﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события "ПриСозданииНаСервере" формы.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Валюта = Объект.ВалютаДокумента;
	
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДата();
	КонецЕсли;
	ЭтотОбъект.ОснованиеСоздания = Параметры.Основание;
	
	// Документ основание.
	Элементы.ДокументОснованиеНадпись.Заголовок = РаботаСФормойДокументаКлиентСервер.СформироватьНадписьДокументОснование(Объект.ДокументОснование);
	
	НовыйМассив = Новый Массив();
	НовыеПараметры = Новый ФиксированныйМассив(НовыйМассив);
	ПараметрыВыбораДокументаОснования = НовыеПараметры;
	// Конец Документ основание.
	
	ПрочитатьРеквизитыКонтрагента(ЭтотОбъект.РеквизитыКонтрагента, Объект.Контрагент);
	
	ОбменСGoogle.ПодключитьОбработчикиСобытияАвтоподбор(ЭтаФорма);
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаВажныеКоманды);
	// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УправлениеФормой();
	
	СтатистикаИспользованияФормКлиент.ПроверитьЗаписатьСтатистикуКоманды(
		"СоздатьНаОсновании.ПоступлениеДСПлан",
		ЭтотОбъект.ВладелецФормы,
		ЭтотОбъект.ОснованиеСоздания
	);
	
КонецПроцедуры

// Процедура - обработчик события ПриЧтенииНаСервере.
//
&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры // ПриЧтенииНаСервере()

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ОбменСGoogle.УвеличитьЗначениеСчетчикаПодсказок(ЭтаФорма);
	
КонецПроцедуры

// Процедура - обработчик события "ПослеЗаписи" формы.
//
&НаКлиенте
Процедура ПослеЗаписи()
	
	Оповестить("ИзменениеДанныхПлатежногоКалендаря");
	
КонецПроцедуры // ПослеЗаписи()

// Процедура - обработчик события ОбработкаОповещения формы.
//
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ПослеЗаписиКонтрагента" Тогда
		Если ЗначениеЗаполнено(Параметр)
			И Объект.Контрагент = Параметр Тогда
			ПрочитатьРеквизитыКонтрагента(ЭтотОбъект.РеквизитыКонтрагента, Параметр);
			УстановитьВидимостьДоговора();
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры // ОбработкаОповещения

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

// Процедура - обработчик события ПриИзменении поля ввода Организация.
//
&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Объект.Номер = "";
	СтруктураДанные = ПолучитьДанныеОрганизацияПриИзменении(
		Объект.Организация,
		Объект.ВалютаДокумента,
		Объект.БанковскийСчет,
		Объект.Касса
	);
	Объект.БанковскийСчет = СтруктураДанные.БанковскийСчет;
	
	// Касса по умолчанию
	Если СтруктураДанные.Свойство("Касса") Тогда
		Объект.Касса = СтруктураДанные.Касса;
		Объект.ВалютаДокумента = СтруктураДанные.ВалютаДокумента;
	КонецЕсли;
	// Конец Касса по умолчанию
	
КонецПроцедуры // ОрганизацияПриИзменении()

// Процедура - обработчик события ПриИзменении поля ввода ВалютаДокумента.
//
&НаКлиенте
Процедура ВалютаДокументаПриИзменении(Элемент)
	
	Если Валюта <> Объект.ВалютаДокумента Тогда
		
		СтруктураДанные = ПолучитьДанныеВалютаДокументаПриИзменении(
			Объект.Организация,
			Валюта,
			Объект.БанковскийСчет,
			Объект.ВалютаДокумента,
			Объект.СуммаДокумента,
			Объект.Дата);
		
		Объект.БанковскийСчет = СтруктураДанные.БанковскийСчет;
		
		Если Объект.СуммаДокумента <> 0 Тогда
			Режим = РежимДиалогаВопрос.ДаНет;
			Ответ = Неопределено;

			ПоказатьВопрос(Новый ОписаниеОповещения("ВалютаДокументаПриИзмененииЗавершение", ЭтотОбъект, Новый Структура("СтруктураДанные", СтруктураДанные)), НСтр("ru = 'Изменилась валюта документа. Пересчитать сумму документа?'"), Режим);
            Возврат;
		КонецЕсли;
		ВалютаДокументаПриИзмененииФрагмент();

		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаДокументаПриИзмененииЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    СтруктураДанные = ДополнительныеПараметры.СтруктураДанные;
    
    
    Ответ = Результат;
    Если Ответ = КодВозвратаДиалога.Да Тогда
        Объект.СуммаДокумента = СтруктураДанные.Сумма;
    КонецЕсли;
    
    ВалютаДокументаПриИзмененииФрагмент();

КонецПроцедуры

&НаКлиенте
Процедура ВалютаДокументаПриИзмененииФрагмент()
    
    Валюта = Объект.ВалютаДокумента;

КонецПроцедуры // ВалютаДокументаПриИзменении()

// Процедура - обработчик события ПриИзменении поля ввода ТипДенежныхСредств.
//
&НаКлиенте
Процедура ТипДенежныхСредствПриИзменении(Элемент)
	
	УстановитьТекущуюСтраницу();
	
КонецПроцедуры // ТипДенежныхСредствПриИзменении()

// Процедура - обработчик события ПриИзменении поля ввода Дата.
// В процедуре определяется ситуация, когда при изменении своей даты документ 
// оказывается в другом периоде нумерации документов, и в этом случае
// присваивает документу новый уникальный номер.
// Переопределяет соответствующий параметр формы.
//
&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	// Обработка события изменения даты.
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;		
	КонецЕсли;
	
КонецПроцедуры // ДатаПриИзменении()

// Процедура - обработчик события ПриИзменении поля ввода Контрагент.
//
&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	
	СтруктураДанные = ПолучитьДанныеКонтрагентПриИзменении(Объект.Дата, Объект.ВалютаДокумента, Объект.Контрагент, Объект.Организация);
	Объект.Договор = СтруктураДанные.Договор;
	
	УстановитьВидимостьДоговора();
	
КонецПроцедуры

// Процедура - обработчик события ПриИзменении поля ввода Касса.
//
&НаКлиенте
Процедура КассаПриИзменении(Элемент)
	
	Объект.ВалютаДокумента = ?(
		ЗначениеЗаполнено(Объект.ВалютаДокумента),
		Объект.ВалютаДокумента,
		ПолучитьВалютуПоУмолчаниюКассыНаСервере(Объект.Касса)
	);
	
КонецПроцедуры // КассаПриИзменении()

// Процедура вызывает обработку заполнения документа по основанию.
//
&НаСервере
Процедура ЗаполнитьПоДокументу(ДокОснование)
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.Заполнить(ДокОснование);
	ЗначениеВРеквизитФормы(Документ, "Объект");
	Модифицированность = Истина;
	
	Валюта = Объект.ВалютаДокумента;
	
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДата();
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьПоДокументу()

// Процедура - обработчик команды ЗаполнитьПоОснованию.
//
&НаКлиенте
Процедура ЗаполнитьПоОснованию(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		ПоказатьПредупреждение(Неопределено, НСтр("ru='Не выбран документ основание!'"));
		Возврат;
	КонецЕсли;
	
	Ответ = Неопределено;

	
	ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьПоОснованиюЗавершение", ЭтотОбъект), НСтр("ru = 'Документ будет полностью перезаполнен по ""Основанию""! Продолжить выполнение операции?'"), РежимДиалогаВопрос.ДаНет, 0);

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОснованиюЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Ответ = Результат;
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		ЗаполнитьПоДокументу(Объект.ДокументОснование);
		
		УправлениеФормой();
		
	КонецЕсли;

КонецПроцедуры // ЗаполнитьПоОснованию()

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(Элемент.ТекстРедактирования, ЭтотОбъект, "Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Проверяет соответствие валюты денежных средств банковского счета и валюты документа,
// в случае несоответствия определяется банковский счет (касса) по умолчанию.
//
// Параметры:
//	Организация - СправочникСсылка.Организации - Организация документа
//	Валюта - СправочникСсылка.Валюты - Валюта документа
//	БанковскийСчет - СправочникСсылка.БанковскиеСчета - Банковский счет документа
//	Касса - СправочникСсылка.Кассы - Касса документа
//
&НаСервереБезКонтекста
Функция ПолучитьБанковскийСчет(Организация, Валюта)
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА Организации.БанковскийСчетПоУмолчанию.ВалютаДенежныхСредств = &ВалютаДенежныхСредств
	|			ТОГДА Организации.БанковскийСчетПоУмолчанию
	|		КОГДА (НЕ БанковскиеСчета.БанковскийСчет ЕСТЬ NULL )
	|			ТОГДА БанковскиеСчета.БанковскийСчет
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК БанковскийСчет
	|ИЗ
	|	Справочник.Организации КАК Организации
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			БанковскиеСчета.Ссылка КАК БанковскийСчет
	|		ИЗ
	|			Справочник.БанковскиеСчета КАК БанковскиеСчета
	|		ГДЕ
	|			БанковскиеСчета.ВалютаДенежныхСредств = &ВалютаДенежныхСредств
	|			И БанковскиеСчета.Владелец = &Организация) КАК БанковскиеСчета
	|		ПО (ИСТИНА)
	|ГДЕ
	|	Организации.Ссылка = &Организация");
	
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ВалютаДенежныхСредств", Валюта);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	СтруктураДанные = Новый Структура();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.БанковскийСчет;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции // ПолучитьБанковскийСчет()

// Проверяет данные с сервера для процедуры ОрганизацияПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеОрганизацияПриИзменении(Организация, Валюта, БанковскийСчет, Касса)
	
	СтруктураДанные = Новый Структура();
	
	СтруктураДанные.Вставить("БанковскийСчет", ПолучитьБанковскийСчет(Организация, Валюта));
	// Касса по умолчанию
	УправлениеНебольшойФирмойСервер.ДобавитьВСтруктуруИнформациюОКассеПоУмолчаниюДляОрганизации(СтруктураДанные, Новый Структура("Организация, Касса", Организация, Касса), Валюта, "ВалютаДокумента");
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеОрганизацияПриИзменении()

// Проверяет данные с сервера для процедуры ВалютаДокументаПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеВалютаДокументаПриИзменении(Организация, Валюта, БанковскийСчет, НоваяВалюта, СуммаДокумента, Дата)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("БанковскийСчет", ПолучитьБанковскийСчет(Организация, НоваяВалюта));
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА КурсыВалют.Кратность <> 0
	|				И (НЕ КурсыВалют.Кратность ЕСТЬ NULL )
	|				И НовыеКурсыВалют.Курс <> 0
	|				И (НЕ НовыеКурсыВалют.Курс ЕСТЬ NULL )
	|			ТОГДА &СуммаДокумента * (КурсыВалют.Курс * НовыеКурсыВалют.Кратность) / (КурсыВалют.Кратность * НовыеКурсыВалют.Курс)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Сумма
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&Дата, Валюта = &Валюта) КАК КурсыВалют
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КурсыВалют.СрезПоследних(&Дата, Валюта = &НоваяВалюта) КАК НовыеКурсыВалют
	|		ПО (ИСТИНА)");
	
	Запрос.УстановитьПараметр("Валюта", Валюта);
	Запрос.УстановитьПараметр("НоваяВалюта", НоваяВалюта);
	Запрос.УстановитьПараметр("СуммаДокумента", СуммаДокумента);
	Запрос.УстановитьПараметр("Дата", Дата);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Если Выборка.Следующий() Тогда
		СтруктураДанные.Вставить("Сумма", Выборка.Сумма);
	Иначе
		СтруктураДанные.Вставить("Сумма", 0);
	КонецЕсли;
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеВалютаДокументаПриИзменении()

// Получает набор данных с сервера для процедуры ДоговорПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеДатаПриИзменении(ДокументСсылка, ДатаНовая, ДатаПередИзменением)
	
	РазностьДат = УправлениеНебольшойФирмойСервер.ПроверитьНомерДокумента(ДокументСсылка, ДатаНовая, ДатаПередИзменением);
		
	СтруктураДанные = Новый Структура;
	
	СтруктураДанные.Вставить(
		"РазностьДат",
		РазностьДат
	);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеДатаПриИзменении()

// Получает набор данных с сервера для процедуры КонтрагентПриИзменении.
//
&НаСервере
Функция ПолучитьДанныеКонтрагентПриИзменении(Дата, ВалютаДокумента, Контрагент, Организация)
	
	СтруктураДанные = Новый Структура();
	
	СтруктураДанные.Вставить(
		"Договор",
		Контрагент.ДоговорПоУмолчанию
	);
	
	ПрочитатьРеквизитыКонтрагента(ЭтотОбъект.РеквизитыКонтрагента, Контрагент);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеКонтрагентПриИзменении()

// Процедура получает валюту кассы по умолчанию.
//
&НаСервереБезКонтекста
Функция ПолучитьВалютуПоУмолчаниюКассыНаСервере(Касса)
	
	Возврат Касса.ВалютаПоУмолчанию;
	
КонецФункции // ПолучитьВалютуПоУмолчаниюКассыНаСервере()

&НаСервереБезКонтекста
Процедура ПрочитатьРеквизитыКонтрагента(СтруктураРеквизитов, знач Контрагент)
	
	Реквизиты = "ВестиРасчетыПоДоговорам";
	
	Если СтруктураРеквизитов = Неопределено Тогда
		СтруктураРеквизитов = Новый Структура(Реквизиты);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		ЗаполнитьЗначенияСвойств(СтруктураРеквизитов, ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Контрагент, Реквизиты));
	Иначе
		СтруктураРеквизитов.ВестиРасчетыПоДоговорам = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеФормой()
	
	УстановитьТекущуюСтраницу();
	УстановитьВидимостьДоговора();
	
КонецПроцедуры

// Устанавливает текущую страницу для вида операции документа.
//
// Параметры:
//	ХозяйственнаяОперация - ПеречислениеСсылка.ХозяйственныеОперации - Хозяйственная операции
//
&НаКлиенте
Процедура УстановитьТекущуюСтраницу()
	
	Если Объект.ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Безналичные") Тогда
		Элементы.БанковскийСчет.Доступность = Истина;
		Элементы.БанковскийСчет.Видимость 	= Истина;
		Элементы.Касса.Видимость 			= Ложь;
		Элементы.ДекорацияРазделитель.Видимость = Ложь;
	ИначеЕсли Объект.ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Наличные") Тогда
		Элементы.Касса.Доступность 			= Истина;
		Элементы.БанковскийСчет.Видимость 	= Ложь;
		Элементы.Касса.Видимость 			= Истина;
		Элементы.ДекорацияРазделитель.Видимость = Ложь;
	Иначе
		Элементы.БанковскийСчет.Доступность = Ложь;
		Элементы.БанковскийСчет.Видимость	= Ложь;
		Элементы.Касса.Доступность 			= Ложь;
		Элементы.Касса.Видимость 			= Ложь;
		Элементы.ДекорацияРазделитель.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры // УстановитьТекущуюСтраницу()

// Процедура устанавливает видимость договора в зависимости от установленного параметра контрагенту.
//
&НаКлиенте
Процедура УстановитьВидимостьДоговора()
	
	Элементы.Договор.Видимость = РеквизитыКонтрагента.ВестиРасчетыПоДоговорам;
	
КонецПроцедуры // УстановитьВидимостьДоговора()

#КонецОбласти

#Область ЗаполнениеОбъектов

&НаКлиенте
Процедура СохранитьДокументКакШаблон(Параметр) Экспорт
	
	ЗаполнениеОбъектовУНФКлиент.СохранитьДокументКакШаблон(Объект, ОтображаемыеРеквизиты(), Параметр);
	
КонецПроцедуры

&НаСервере
Функция ОтображаемыеРеквизиты()
	
	Возврат ЗаполнениеОбъектовУНФ.ОтображаемыеРеквизиты(ЭтотОбъект);
	
КонецФункции

#КонецОбласти

#Область ОбменСGoogle

&НаКлиенте
Процедура Подключаемый_ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОбменСGoogleКлиент.Подключаемый_ОбработкаВыбора(
	ЭтотОбъект,
	Элемент,
	ВыбранноеЗначение,
	СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_АвтоПодбор(Элемент, Текст, ДанныеВыбора, Параметры, Ожидание, СтандартнаяОбработка)
	
	ОбменСGoogleКлиент.Подключаемый_АвтоПодбор(
	ЭтотОбъект,
	Элемент,
	Текст,
	ДанныеВыбора,
	Параметры,
	Ожидание,
	СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти

#Область Основание

&НаСервереБезКонтекста
Функция ПолучитьСписокДляВыбораДокументаОснования()
	
	СписокОснований = Новый СписокЗначений;
	
	СписокОснований.Добавить("Документ.АктВыполненныхРабот.ФормаВыбора", "Акт выполненных работ");
	СписокОснований.Добавить("Документ.НачислениеНалогов.ФормаВыбора", "Начисление налогов");
	Если ПолучитьФункциональнуюОпцию("УчетВнеоборотныхАктивов") Тогда
		СписокОснований.Добавить("Документ.ПередачаВА.ФормаВыбора", "Продажа имущества");
	КонецЕсли;
	СписокОснований.Добавить("Документ.РасходнаяНакладная.ФормаВыбора", "Расходная накладная");
	СписокОснований.Добавить("Документ.ПриходнаяНакладная.ФормаВыбора", "Приходная накладная");
	Если ПолучитьФункциональнуюОпцию("КредитыИЗаймы") Тогда
		СписокОснований.Добавить("Документ.НачисленияПоКредитамИЗаймам.ФормаВыбора", "Начисления по кредитам и займам");
		СписокОснований.Добавить("Документ.ДоговорКредитаИЗайма.ФормаВыбора", "Договор кредита (займа)");
	КонецЕсли;
	Если ПолучитьФункциональнуюОпцию("ПлатежныйКалендарь") Тогда
		СписокОснований.Добавить("Документ.ПеремещениеДСПлан.ФормаВыбора", "Перемещение денег (план)");
		СписокОснований.Добавить("Документ.ПоступлениеДСПлан.ФормаВыбора", "Поступление денег (план)");
	КонецЕсли;
	СписокОснований.Добавить("Документ.ЗаказПокупателя.ФормаВыбора", "Заказ покупателя");
	СписокОснований.Добавить("Документ.СчетНаОплату.ФормаВыбора", "Счет на оплату");
	
	СписокОснований.СортироватьПоПредставлению(НаправлениеСортировки.Возр);
	
	Возврат СписокОснований;
	
КонецФункции

&НаКлиенте
Процедура ДокументОснованиеНадписьОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если НавигационнаяСсылкаФорматированнойСтроки = "удалить" Тогда
		
		Объект.ДокументОснование = Неопределено;
		Элементы.ДокументОснованиеНадпись.Заголовок = РаботаСФормойДокументаКлиентСервер.СформироватьНадписьДокументОснование(Неопределено);
		Модифицированность = Истина;
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "заполнить" Тогда
		ЗаполнитьПоОснованиюНачало();
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "выбрать" Тогда
		
		//Выбрать основание
		ОписаниеОповещения = Новый ОписаниеОповещения("ВыборТипаОснованияЗавершение", ЭтотОбъект);
		ПоказатьВыборИзМеню(ОписаниеОповещения, ПолучитьСписокДляВыбораДокументаОснования(), Элемент);
		
	ИначеЕсли НавигационнаяСсылкаФорматированнойСтроки = "открыть" Тогда
		
		Если НЕ ЗначениеЗаполнено(Объект.ДокументОснование) тогда
			возврат;
		КонецЕсли;
		
		РаботаСФормойДокументаКлиент.ОткрытьФормуДокументаПоТипу(Объект.ДокументОснование);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборТипаОснованияЗавершение(ВыбИмяФормы, Параметры) Экспорт
	
	Если ВыбИмяФормы<>Неопределено Тогда
		
		СтруктураПараметровОтбора = Новый Структура();
		Для каждого элОтбора Из ПараметрыВыбораДокументаОснования Цикл
			ИмяПоляОтбора = СтрЗаменить(элОтбора.Имя,"Отбор.","");
			СтруктураПараметровОтбора.Вставить(ИмяПоляОтбора, элОтбора.Значение);
		КонецЦикла;
		_ОповещениеОЗакрытии = Новый ОписаниеОповещения("ВыбратьОснованиеЗавершение", ЭтотОбъект);
		ОткрытьФорму(ВыбИмяФормы.Значение, СтруктураПараметровОтбора, ЭтотОбъект, ,,,_ОповещениеОЗакрытии);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьОснованиеЗавершение(ВыбЗначение, Параметры) Экспорт

	Если ВыбЗначение<>Неопределено Тогда
		Объект.ДокументОснование = ВыбЗначение;
		Элементы.ДокументОснованиеНадпись.Заголовок = РаботаСФормойДокументаКлиентСервер.СформироватьНадписьДокументОснование(ВыбЗначение);
		Модифицированность = Истина;
		
		ЗаполнитьПоОснованиюНачало();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоОснованиюНачало() Экспорт

	ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьПоОснованиюЗавершение", ЭтотОбъект);
	ПоказатьВопрос(
		ОписаниеОповещения, 
		НСтр("ru = 'Заполнить документ по выбранному основанию?'"), 
		РежимДиалогаВопрос.ДаНет, 0);		

КонецПроцедуры

#КонецОбласти
