﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Заголовок") Тогда
		Заголовок = НСтр("ru = 'Подсказка: '") + Параметры.Заголовок;
	КонецЕсли;
	
	Если Параметры.Свойство("КлючПодсказки") Тогда
		Если СтрНайти(Параметры.КлючПодсказки, "ГрафическаяСхема") > 0 Тогда
			ГрафическаяСхема = Обработки.МенеджерПодсказок.ПолучитьМакет(Параметры.КлючПодсказки);
			Элементы.СтраницыПоТипамМакетов.ТекущаяСтраница = Элементы.СтраницаГрафическаяСхема;
			Элементы.ГруппаПодвал54ФЗ.Видимость = (Параметры.КлючПодсказки = "ГрафическаяСхема_Розница");
		Иначе
			МакетПодсказки = Обработки.МенеджерПодсказок.ПолучитьМакет(Параметры.КлючПодсказки).ПолучитьТекст();
			Элементы.СтраницыПоТипамМакетов.ТекущаяСтраница = Элементы.СтраницаHTML;
			Элементы.ГруппаПодвал54ФЗ.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ИспользоватьПодключаемоеОборудование = ПолучитьФункциональнуюОпцию("ИспользоватьПодключаемоеОборудование");
	ИспользоватьДисконтныеКарты = ПолучитьФункциональнуюОпцию("ИспользоватьДисконтныеКарты");
	ИспользоватьСкидкиНаценки = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическиеСкидкиНаценки") ИЛИ
		ПолучитьФункциональнуюОпцию("ИспользоватьРучныеСкидкиНаценкиПродажи");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура МакетПодсказкиПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	Если СтрНайти(ДанныеСобытия.href, "unf://") <> 0 Тогда
		
		СтандартнаяОбработка = Ложь;
		СтрокаИмяФормы = ДанныеСобытия.href;
		Если СтрНайти(ДанныеСобытия.href, "v8cfgHelp") <> 0 Тогда
			СтрокаИмяФормы = СтрЗаменить(СтрокаИмяФормы, "v8cfgHelp/v8config/", "");
		КонецЕсли;
		СтрокаИмяФормы = СтрЗаменить(СтрокаИмяФормы, "unf://", "");
		СтрокаИмяФормы = СтрЗаменить(СтрокаИмяФормы, "/", "");
		Попытка
			ОткрытьФорму(СтрокаИмяФормы);
		Исключение
		КонецПопытки;
		
	ИначеЕсли СтрНайти(ДанныеСобытия.href, "e1cib/") > 0 Тогда
		
		СтандартнаяОбработка = Ложь;
		НавигационнаяСсылка = Сред(ДанныеСобытия.href, СтрНайти(ДанныеСобытия.href, "e1cib/"));
		ПерейтиПоНавигационнойСсылке(НавигационнаяСсылка);
		
	ИначеЕсли СтрНайти(ДанныеСобытия.href, "http") > 0 Тогда
		
		СтандартнаяОбработка = Ложь;
		ПерейтиПоНавигационнойСсылке(ДанныеСобытия.href);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ГрафическаяСхемаВыбор(Элемент)
	
	ЭлементСхемы = Элементы.ГрафическаяСхема.ТекущийЭлемент;
	
	Если ЭлементСхемы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяЭлемента = ЭлементСхемы.Имя;
	
	// Розница
	Если ИмяЭлемента = "ДействиеЧекККМ" ИЛИ
		ИмяЭлемента = "ДействиеЧекККМЗаказы" ИЛИ
		ИмяЭлемента = "ЧекККМНаВозвратЗаказы" ИЛИ
		ИмяЭлемента = "ЧекККМНаВозврат" Тогда
		
		ОткрытьФорму("ЖурналДокументов.ЧекиККМ.ФормаСписка");
		
	ИначеЕсли ИмяЭлемента = "ДействиеОтчетОРозничныхПродажах" ИЛИ
		
		ИмяЭлемента = "ДействиеОтчетОРозничныхПродажахЗаказы" ИЛИ
		ИмяЭлемента = "ДействиеОтчетОРозничныхПродажахАвтономноеРМ" Тогда
		ОткрытьФорму("Документ.ОтчетОРозничныхПродажах.ФормаСписка");
		
	ИначеЕсли ИмяЭлемента = "ДекорацияКассыККМ" Тогда
		
		ОткрытьФорму("Справочник.КассыККМ.ФормаСписка");
		
	ИначеЕсли ИмяЭлемента = "ДекорацияНастройки" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РазделПоУмолчанию", "Продажи");
		
		ОткрытьФорму("Обработка.НастройкаПрограммы.Форма",
			ПараметрыФормы,,,,,,);
		
	ИначеЕсли ИмяЭлемента = "ДекорацияВводНаОснованииПриемВыручки" Тогда
		
		ОткрытьФорму("Обработка.МенеджерПодсказок.Форма.ПросмотрКартинки", Новый Структура("ИмяКартинки", "Розница_РозничнаяВыручка_ВводНаОсновании"));
		
	ИначеЕсли ИмяЭлемента = "ДекорацияКакВключитьФО_ИспользоватьЗаказы" Тогда
		
		ОткрытьФорму("Обработка.МенеджерПодсказок.Форма.ПросмотрКартинки", Новый Структура("ИмяКартинки", "Розница_КакВключитьФО_ИспользоватьЗаказы"));
		
	ИначеЕсли ИмяЭлемента = "ДействиеПеремещениеДенегВКассуККМ" ИЛИ
		
		ИмяЭлемента = "ДействиеПеремещениеДенегВКассуККМЗаказы" Тогда
		ДвиженияДенежныхСредствКлиент.СоздатьДокумент("РасходИзКассы", "ПеремещениеВКассуККМ", Неопределено, "ДокументыПоКассе");
		
	ИначеЕсли ИмяЭлемента = "ДействиеРозничнаяВыручка" ИЛИ
		
		ИмяЭлемента = "ДействиеРозничнаяВыручкаЗаказы" ИЛИ
		ИмяЭлемента = "ДействиеРозничнаяВыручкаАвтономноеРМ" Тогда
		ДвиженияДенежныхСредствКлиент.СоздатьДокумент("ПоступлениеВКассу", "РозничнаяВыручка", Неопределено, "ДокументыПоКассе");
		
	ИначеЕсли ИмяЭлемента = "ДействиеИнвентаризация" ИЛИ
		
		ИмяЭлемента = "ДействиеИнвентаризацияСуммовойУчет" Тогда
		ОткрытьФорму("Документ.ИнвентаризацияЗапасов.ФормаОбъекта");
		
	ИначеЕсли ИмяЭлемента = "ДействиеЗаказПокупателя" Тогда
		
		ОткрытьФорму("Документ.ЗаказПокупателя.ФормаСписка");
		
	ИначеЕсли ИмяЭлемента = "СправочникПодключаемоеОборудование" Тогда
		
		Если ИспользоватьПодключаемоеОборудование Тогда
			ОткрытьФорму("Справочник.ПодключаемоеОборудование.ФормаСписка");
		Иначе
			ОбовещениеПослеОтветаНаВопрос = Новый ОписаниеОповещения("ОбработкаОтветаНаВопросОНастройкеПодключаемогоОборудования", ЭтотОбъект);
			ПоказатьВопрос(ОбовещениеПослеОтветаНаВопрос, НСтр("ru = 'Необходимо предварительно включить опцию ""Подключаемое оборудование"". Перейти к настройкам опций?'"), РежимДиалогаВопрос.ДаНет);
		КонецЕсли;
		
	ИначеЕсли ИмяЭлемента = "ДействиеПеремещениеЗапасовАвтономноеРМ" ИЛИ
		
		ИмяЭлемента = "ДействиеПеремещениеЗапасовСуммовойУчет" Тогда
		ОткрытьФорму("Документ.ПеремещениеЗапасов.ФормаСписка");
		
	ИначеЕсли ИмяЭлемента = "ДействиеПриемРозничнойВыручкиСуммовойУчет" Тогда
		
		ДвиженияДенежныхСредствКлиент.СоздатьДокумент("ПоступлениеВКассу", "РозничнаяВыручкаСуммовойУчет", Неопределено, "ДокументыПоКассе");
		
	ИначеЕсли ИмяЭлемента = "ДействиеПереоценкаСуммовойУчет" Тогда
		
		ОткрытьФорму("Документ.ПереоценкаВРозницеСуммовойУчет.ФормаОбъекта");
		
	ИначеЕсли ИмяЭлемента = "ОткрытьРМК" Тогда
		
		ПерейтиПоНавигационнойСсылке("e1cib/command/Документ.ЧекККМ.Команда.РабочееМестоКассира");
		
	// Отчеты
	ИначеЕсли ИмяЭлемента = "ДекорацияОтчеты" Тогда
		
		Форма = ОткрытьФорму("ОбщаяФорма.ФормаСпискаОтчетов");
		Форма.Инициализировать("Продажи");
		
	ИначеЕсли ИмяЭлемента = "ДекорацияОтчетыЗаказы" Тогда
		
		Форма = ОткрытьФорму("ОбщаяФорма.ФормаСпискаОтчетов");
		Форма.Инициализировать("Продажи, Заказы");
		
	ИначеЕсли ИмяЭлемента = "ДекорацияОтчетыРозница" Тогда
		
		Форма = ОткрытьФорму("ОбщаяФорма.ФормаСпискаОтчетов");
		Форма.Инициализировать("Розница");
		
	// Конец Отчеты
	// Учебные материалы
	ИначеЕсли ИмяЭлемента = "ДекорацияВидеоРолики" Тогда
		
		АдресСтраницы = "https://www.youtube.com/watch?v=iFJcMVZ2W98&list=PLCusuGHiDvVnVmj9h6TnylpRG-PZ6ngOV";
		ПерейтиПоНавигационнойСсылке(АдресСтраницы);
		
	ИначеЕсли ИмяЭлемента = "ДекорацияСамоучитель" Тогда
		
		АдресСтраницы = "http://its.1c.ru/db/unflearn#content:5:1";
		ПерейтиПоНавигационнойСсылке(АдресСтраницы);
		
	ИначеЕсли ИмяЭлемента = "ДекорацияОписаниеКонфигурации" Тогда
		
		АдресСтраницы = "http://its.1c.ru/db/unfdoc#content:5:1:issogl1_2.10_розничные_продажи";
		ПерейтиПоНавигационнойСсылке(АдресСтраницы);
		
	// Конец Учебные материалы
	// Конец Розница
	
	ИначеЕсли СтрНайти(ИмяЭлемента, "Справочник") > 0 Тогда
		
		ОткрытьФорму("Справочник."+СтрЗаменить(ИмяЭлемента, "Справочник", "")+".ФормаСписка");
		
	ИначеЕсли СтрНайти(ИмяЭлемента, "Обработка") > 0 Тогда
		
		Если ИмяЭлемента = "ОбработкаДисконтныеКарты" И НЕ ИспользоватьДисконтныеКарты Тогда
			ОбовещениеПослеОтветаНаВопрос = Новый ОписаниеОповещения("ОбработкаОтветаНаВопросОДисконтныхКартах", ЭтотОбъект);
			ПоказатьВопрос(ОбовещениеПослеОтветаНаВопрос, НСтр("ru = 'Необходимо предварительно включить опцию ""Дисконтные карты"". Перейти к настройкам опций?'"), РежимДиалогаВопрос.ДаНет);
			Возврат;
		ИначеЕсли ИмяЭлемента = "ОбработкаВидыСкидокНаценокРучныеИАвтоматические" И НЕ ИспользоватьСкидкиНаценки Тогда
			ОбовещениеПослеОтветаНаВопрос = Новый ОписаниеОповещения("ОбработкаОтветаНаВопросОСкидках", ЭтотОбъект);
			ПоказатьВопрос(ОбовещениеПослеОтветаНаВопрос, НСтр("ru = 'Необходимо предварительно включить опцию ""Скидки и наценки в продажах"" или ""Автоматические скидки"". 
				|Перейти к настройкам опций?'"), РежимДиалогаВопрос.ДаНет);
			Возврат;
		КонецЕсли;
		
		ОткрытьФорму("Обработка."+СтрЗаменить(ИмяЭлемента, "Обработка", "")+".Форма");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияПодключитьКассыК_ОФДНажатие(Элемент)
	
	ПерейтиПоНавигационнойСсылке("http://v8.1c.ru/cnt.jsp/:kd_unf:/https://portal.1c.ru/applications/56");
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияВсеО54ФЗНажатие(Элемент)
	
	ПерейтиПоНавигационнойСсылке("http://v8.1c.ru/cnt.jsp/:kd_unf:/http://v8.1c.ru/kkt");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбработкаОтветаНаВопросОНастройкеПодключаемогоОборудования(ВыбраннаяКнопка, ПараметрыОтвета) Экспорт
	
	Если ВыбраннаяКнопка = КодВозвратаДиалога.Да Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РазделПоУмолчанию", "ПодключаемоеОборудование");
		
		ОткрытьФорму("Обработка.НастройкаПрограммы.Форма",
			ПараметрыФормы,,,,,,);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОтветаНаВопросОДисконтныхКартах(ВыбраннаяКнопка, ПараметрыОтвета) Экспорт
	
	Если ВыбраннаяКнопка = КодВозвратаДиалога.Да Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РазделПоУмолчанию", "Продажи");
		// Поисковую строку задавать не нужно, т.к. опция ИспользоватьДисконтныеКарты зависит от опции ИспользоватьСкидкиИНаценкиВПродажах.
		// А если установить строку поиска, то будет видна только опция ИспользоватьДисконтныеКарты.
		
		ОткрытьФорму("Обработка.НастройкаПрограммы.Форма",
			ПараметрыФормы,,,,,,);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОтветаНаВопросОСкидках(ВыбраннаяКнопка, ПараметрыОтвета) Экспорт
	
	Если ВыбраннаяКнопка = КодВозвратаДиалога.Да Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РазделПоУмолчанию", "Продажи");
		
		ОткрытьФорму("Обработка.НастройкаПрограммы.Форма",
			ПараметрыФормы,,,,,,);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
