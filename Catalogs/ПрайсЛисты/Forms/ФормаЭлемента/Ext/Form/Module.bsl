﻿
#Область СлужебныеМетоды

&НаКлиенте
Процедура ИзменитьВариантОтбораНоменклатуры()
	
	Если Объект.ИерархияСодержимого = КэшЗначений.ИерархияНоменклатуры Тогда
		
		Элементы.СтраницыСостава.ТекущаяСтраница = Элементы.СтраницаОтборыГруппыНоменклатуры;
		
		Объект.ЦеновыеГруппы.Очистить();
		Объект.КатегорииНоменклатуры.Очистить();
		
	ИначеЕсли Объект.ИерархияСодержимого = КэшЗначений.ИерархияЦеновыхГрупп Тогда
		
		Элементы.СтраницыСостава.ТекущаяСтраница = Элементы.СтраницаОтборыЦеновыеГруппы;
		
		Объект.Номенклатура.Очистить();
		Объект.КатегорииНоменклатуры.Очистить();
		
	ИначеЕсли Объект.ИерархияСодержимого = КэшЗначений.ИерархияКатегорийНоменклатуры Тогда
		
		Элементы.СтраницыСостава.ТекущаяСтраница = Элементы.СтраницаОтборыКатегорииНоменклатуры;
		
		Объект.Номенклатура.Очистить();
		Объект.ЦеновыеГруппы.Очистить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УправлениеСвойствамиЭлементовФормы()
	
	Если Объект.ПечатьПрайсЛиста = КэшЗначений.Полотно Тогда
		
		Элементы.СтраницыВидЦен.ТекущаяСтраница = Элементы.СтраницаВидЦенСписок;
		Элементы.ДекорацияОбразецПрайсЛиста.Картинка = БиблиотекаКартинок.ВариантПрайслистаПолотно;
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Валюта", "Доступность", Истина);
		
	ИначеЕсли Объект.ПечатьПрайсЛиста = КэшЗначений.ДвеКолонки Тогда
		
		Элементы.СтраницыВидЦен.ТекущаяСтраница = Элементы.СтраницаВидЦенЗапись;
		Элементы.ДекорацияОбразецПрайсЛиста.Картинка = БиблиотекаКартинок.ВариантПрайслистаКолонки;
		
	ИначеЕсли Объект.ПечатьПрайсЛиста = КэшЗначений.Диафильм Тогда
		
		Элементы.СтраницыВидЦен.ТекущаяСтраница = Элементы.СтраницаВидЦенЗапись;
		Элементы.ДекорацияОбразецПрайсЛиста.Картинка = БиблиотекаКартинок.ВариантПрайслистаДиафильм;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВариантПечатиПрайсЛиста()
	
	Если Объект.ПечатьПрайсЛиста = КэшЗначений.Полотно Тогда
		
		// не используется...
		
	ИначеЕсли Объект.ПечатьПрайсЛиста = КэшЗначений.ДвеКолонки Тогда
		
		Для каждого Строка Из Объект.ПредставлениеНоменклатуры Цикл
			
			Строка.Использование = (Строка.РеквизитНоменклатуры = "Артикул" ИЛИ Строка.РеквизитНоменклатуры = "Наименование");
			
		КонецЦикла;
		ЗаполнитьПредставлениеНоменклатуры();
		
		КоличествоВидовЦен = Объект.ВидыЦен.Количество();
		Если КоличествоВидовЦен = 0 Тогда
			
			НоваяСтрока			= Объект.ВидыЦен.Добавить();
			НоваяСтрока.ВидЦен	= КэшЗначений.ОптоваяЦена;
			// Объект.Валюта		= КэшЗначений.ВалютаОптовойЦены;
			
		Иначе
			
			// Объект.Валюта = ПолучитьВалютуЦены(Объект.ВидыЦен[0].ВидЦен);
			
		КонецЕсли;
		
		Объект.ПредставлениеОстатков = 1;
		Объект.ФормироватьПоНаличию = Ложь;
		
	ИначеЕсли Объект.ПечатьПрайсЛиста = КэшЗначений.Диафильм Тогда
		
		Для каждого Строка Из Объект.ПредставлениеНоменклатуры Цикл
			
			Строка.Использование = (Строка.РеквизитНоменклатуры = "Артикул" ИЛИ Строка.РеквизитНоменклатуры = "НаименованиеПолное");
			
		КонецЦикла;
		ЗаполнитьПредставлениеНоменклатуры();
		
		КоличествоВидовЦен = Объект.ВидыЦен.Количество();
		Если КоличествоВидовЦен = 0 Тогда
			
			НоваяСтрока			= Объект.ВидыЦен.Добавить();
			НоваяСтрока.ВидЦен	= КэшЗначений.ОптоваяЦена;
			Объект.Валюта		= КэшЗначений.ВалютаОптовойЦены;
			
		Иначе
			
			Объект.Валюта = ПолучитьВалютуЦены(Объект.ВидыЦен[0].ВидЦен);
			
		КонецЕсли;
		
	КонецЕсли;
	
	УправлениеСвойствамиЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПредставлениеНоменклатуры()
	
	СоставРеквизитов = "";
	Для каждого Строка Из Объект.ПредставлениеНоменклатуры Цикл
		
		Если Строка.Использование Тогда
			
			СоставРеквизитов = СоставРеквизитов + ?(ПустаяСтрока(СоставРеквизитов), "", ", ") + Строка.РеквизитПредставление;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если Объект.ПечатьПрайсЛиста = КэшЗначений.Диафильм Тогда
		
		СоставРеквизитов = СоставРеквизитов + НСтр("ru =', Колонок: '") + Объект.КоличествоКолонок + НСтр("ru =', Размер: '") + Объект.КартинкаШирина + НСтр("ru =' х '") + Объект.КартинкаВысота;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьВалютуЦены(ВидЦен)
	
	Возврат ВидЦен.ВалютаЦены;
	
КонецФункции

&НаКлиенте
Процедура УдалитьИзбыточныеСтроки(Отказ)
	
	КоличествоВидовЦен = Объект.ВидыЦен.Количество();
	Если КоличествоВидовЦен > 1 Тогда
		
		Пока КоличествоВидовЦен > 1 Цикл
			
			Объект.ВидыЦен.Удалить(КоличествоВидовЦен - 1);
			
			КоличествоВидовЦен = КоличествоВидовЦен - 1;
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Объект.Валюта = Константы.НациональнаяВалюта.Получить();
		
		НоваяСтрока			= Объект.ВидыЦен.Добавить();
		НоваяСтрока.ВидЦен	= Справочники.ВидыЦен.Оптовая;
		
	КонецЕсли;
	
	Если Объект.ПредставлениеНоменклатуры.НайтиСтроки(Новый Структура("Использование", Истина)).Количество() = 0 Тогда
		
		ТаблицаПредставлений = Неопределено;
		Справочники.ПрайсЛисты.ДоступныеПоляНоменклатуры(ТаблицаПредставлений);
		Объект.ПредставлениеНоменклатуры.Загрузить(ТаблицаПредставлений);
		
	КонецЕсли;
	
	Если ПустаяСтрока(Объект.Наименование) Тогда
		
		Объект.Наименование = Нстр("ru ='Прайс-лист'");
		
	КонецЕсли;
	
	Если ПустаяСтрока(Объект.ПоложениеТекстаОтносительноМеткиНовинка) Тогда
		
		Объект.ПоложениеТекстаОтносительноМеткиНовинка = "Под текстом";
		
	КонецЕсли;
	
	КэшЗначений = Новый Структура;
	КэшЗначений.Вставить("ИерархияНоменклатуры", Перечисления.ИерархияПрайсЛистов.ИерархияНоменклатуры);
	КэшЗначений.Вставить("ИерархияЦеновыхГрупп", Перечисления.ИерархияПрайсЛистов.ИерархияЦеновыхГрупп);
	КэшЗначений.Вставить("ИерархияКатегорийНоменклатуры", Перечисления.ИерархияПрайсЛистов.ИерархияКатегорийНоменклатуры);
	
	КэшЗначений.Вставить("Полотно", 				Перечисления.ВариантыПечатиПрайсЛиста.Полотно);
	КэшЗначений.Вставить("ДвеКолонки",				Перечисления.ВариантыПечатиПрайсЛиста.ДвеКолонки);
	КэшЗначений.Вставить("Диафильм",				Перечисления.ВариантыПечатиПрайсЛиста.Диафильм);
	
	КэшЗначений.Вставить("ОптоваяЦена",				Справочники.ВидыЦен.Оптовая);
	КэшЗначений.Вставить("ВалютаОптовойЦены",		Справочники.ВидыЦен.Оптовая.ВалютаЦены);
	
	Если НЕ ПолучитьФункциональнуюОпцию("УчетВалютныхОпераций") Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаИерархияВалюта", "Заголовок", НСтр("ru ='Группировка прайс-листа'"));
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Организация", 		"Доступность", Объект.ВыводитьКонтактнуюИнформацию);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДатаФормирования",	"Доступность", Объект.ВыводитьДатуФормирования);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ИзменитьВариантОтбораНоменклатуры();
	УправлениеСвойствамиЭлементовФормы();
	ЗаполнитьПредставлениеНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Объект.ПечатьПрайсЛиста = КэшЗначений.ДвеКолонки Тогда
		
		УдалитьИзбыточныеСтроки(Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СобытияЭлементовФормы

&НаКлиенте
Процедура ИерархияПриИзменении(Элемент)
	
	ИзменитьВариантОтбораНоменклатуры();
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьПрайсЛистаПриИзменении(Элемент)
	
	ИзменитьВариантПечатиПрайсЛиста();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоставРеквизитовНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("ПредставлениеНоменклатуры", Объект.ПредставлениеНоменклатуры);
	ПараметрыОткрытияФормы.Вставить("ПредставлениеОстатков", Объект.ПредставлениеОстатков);
	ПараметрыОткрытияФормы.Вставить("ПечатьПрайсЛиста", Объект.ПечатьПрайсЛиста);
	
	ПараметрыОткрытияФормы.Вставить("КоличествоКолонок", Объект.КоличествоКолонок);
	ПараметрыОткрытияФормы.Вставить("КартинкаШирина", Объект.КартинкаШирина);
	ПараметрыОткрытияФормы.Вставить("КартинкаВысота", Объект.КартинкаВысота);
	ПараметрыОткрытияФормы.Вставить("ИзменятьРазмерПропорционально", Объект.ИзменятьРазмерПропорционально);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("СоставРеквизитовПослеРедактирования", ЭтотОбъект);
	Если Объект.ПечатьПрайсЛиста = КэшЗначений.Полотно Тогда
		
		ОткрытьФорму("Справочник.ПрайсЛисты.Форма.ФормаСоставРеквизитов", ПараметрыОткрытияФормы, ЭтотОбъект, , , , ОписаниеОповещения);
		
	ИначеЕсли Объект.ПечатьПрайсЛиста = КэшЗначений.ДвеКолонки 
		ИЛИ Объект.ПечатьПрайсЛиста = КэшЗначений.Диафильм Тогда
		
		ОткрытьФорму("Справочник.ПрайсЛисты.Форма.ФормаСоставРеквизитовДвеКолонки", ПараметрыОткрытияФормы, ЭтотОбъект, , , , ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключенияПрайсЛиста(Команда)
	
	Отбор = Новый Структура;
	Отбор.Вставить("ПрайсЛист", Объект.Ссылка);
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("Отбор", Отбор);
	
	ОткрытьФорму("РегистрСведений.ИсключенияПрайсЛистов.ФормаСписка", ПараметрыОткрытия, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиИнтерактивныхДействий

&НаКлиенте
Процедура СоставРеквизитовПослеРедактирования(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатЗакрытия) = Тип("Структура") Тогда
		
		Если РезультатЗакрытия.РезультатЗакрытия = КодВозвратаДиалога.ОК Тогда
			
			Объект.ПредставлениеНоменклатуры.Очистить();
			Для каждого Строка Из РезультатЗакрытия.ПредставлениеНоменклатуры Цикл
				
				ЗаполнитьЗначенияСвойств(Объект.ПредставлениеНоменклатуры.Добавить(), Строка);
				
			КонецЦикла;
			
			Объект.КоличествоКолонок = РезультатЗакрытия.КоличествоКолонок;
			Объект.КартинкаШирина = РезультатЗакрытия.КартинкаШирина;
			Объект.КартинкаВысота = РезультатЗакрытия.КартинкаВысота;
			Объект.ИзменятьРазмерПропорционально = РезультатЗакрытия.ИзменятьРазмерПропорционально;
			
			ЗаполнитьПредставлениеНоменклатуры();
			
			Объект.ПредставлениеОстатков = РезультатЗакрытия.ПредставлениеОстатков;
			Модифицированность = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыводитьКонтактнуюИнформациюПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "Организация", "Доступность", Объект.ВыводитьКонтактнуюИнформацию);
	
КонецПроцедуры

&НаКлиенте
Процедура УказатьДатуФормированияПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДатаФормирования", "Доступность", Объект.ВыводитьДатуФормирования);
	
КонецПроцедуры

#КонецОбласти