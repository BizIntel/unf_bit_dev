﻿
&НаКлиенте
Перем ФормаДлительнойОперации;

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеВыполненияФоновогоЗадания()
	
	ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
	
	ПоказатьПредупреждение(,Нстр("ru ='Цены номенклатуры.
	|Загрузка данных завершена.'"));
	
КонецПроцедуры

&НаСервере
Процедура ФоновоеЗаданиеВыполнено(Прогресс)
	
	Попытка
		
		ПараметрыДлительнойОперации.ЗаданиеВыполнено = ДлительныеОперации.ЗаданиеВыполнено(ПараметрыДлительнойОперации.ИдентификаторЗадания);
		
		Если НЕ ПараметрыДлительнойОперации.ЗаданиеВыполнено Тогда
			
			Прогресс = ДлительныеОперации.ПрочитатьПрогресс(ПараметрыДлительнойОперации.ИдентификаторЗадания);
			
		КонецЕсли;
		
	Исключение
		
		ПараметрыДлительнойОперации.ЗаданиеВыполнено = Истина;
		ВызватьИсключение Нстр("ru ='Ошибка'") + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ФоновоеЗаданиеПроверитьНаКлиенте()
	Перем Прогресс;
	
	ФоновоеЗаданиеВыполнено(Прогресс);
	
	Если ПараметрыДлительнойОперации.ЗаданиеВыполнено = Истина Тогда
		
		ПослеВыполненияФоновогоЗадания();
		
	Иначе
		
		Если ФормаДлительнойОперации = Неопределено Тогда
			
			ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтотОбъект, ПараметрыДлительнойОперации.ИдентификаторЗадания);
			
		ИначеЕсли ТипЗнч(Прогресс) = Тип("Структура")
			И Прогресс.Свойство("Текст") Тогда
			
			МассивСтрок = Новый Массив;
			МассивСтрок.Добавить(НСтр("ru = 'Пожалуйста, подождите...'"));
			МассивСтрок.Добавить(Символы.ПС);
			МассивСтрок.Добавить(Прогресс.Текст);
			
			ФормаДлительнойОперации.Элементы.ДекорацияПоясняющийТекстДлительнойОперации.Заголовок = СтрСоединить(МассивСтрок);
			
		КонецЕсли;
		
		ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыДлительнойОперации.ПараметрыОбработчика);
		ПодключитьОбработчикОжидания("ФоновоеЗаданиеПроверитьНаКлиенте", ПараметрыДлительнойОперации.ПараметрыОбработчика.ТекущийИнтервал, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьНеобходимостьПодключенияОбработчикаОжидания()
	
	Если ПараметрыДлительнойОперации.ЗаданиеВыполнено = Истина Тогда
		
		ПослеВыполненияФоновогоЗадания();
		
	Иначе
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыДлительнойОперации.ПараметрыОбработчика);
		ПодключитьОбработчикОжидания("ФоновоеЗаданиеПроверитьНаКлиенте", 1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
// Процедура сохраняет выбранный элемент в настройки
//
Процедура УстановитьОсновнойЭлемент(ВыбранныйЭлемент)
	
	Если ВыбранныйЭлемент <> УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеНастройки("ОсновнойВидЦенПродажи") Тогда
		УправлениеНебольшойФирмойСервер.УстановитьНастройкуПользователя(ВыбранныйЭлемент, "ОсновнойВидЦенПродажи");	
		УправлениеНебольшойФирмойСервер.ВыделитьЖирнымОсновнойЭлемент(ВыбранныйЭлемент, Список);
	КонецЕсли; 
		
КонецПроцедуры

&НаСервере
Процедура ПолучитьНоменклатуруСЦеной(МассивВидовЦен, АдресВременногоХранилища)
	
	ДобавляемыеСтроки = Новый ДеревоЗначений;
	
	// 1. Получим СКД
	ИмяСхемыКД = "ПоВидамЦенСЦеной";
	СхемаКомпоновкиДанных = Обработки.Ценообразование.ПолучитьМакет(ИмяСхемыКД);
	
	// 2. создаем настройки для схемы 
	НастройкиКомпоновкиДанных = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	
	// 2.1 установим значения параметров
	ПараметрКД = СхемаКомпоновкиДанных.Параметры.Найти("МассивВидовЦен");
	ПараметрКД.Значение = МассивВидовЦен;
	
	ПараметрКД = СхемаКомпоновкиДанных.Параметры.Найти("ОтборПоПериоду");
	ПараметрКД.Значение = ТекущаяДатаСеанса();
		
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ОтборПоПериоду", "Период < &ОтборПоПериоду");
	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос = ТекстЗапроса;
	
	ТекстЗапроса = СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос;
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ОтборПоХарактеристикам", "Характеристика = Значение(Справочник.ХарактеристикиНоменклатуры.ПустаяСсылка)");
	СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос = ТекстЗапроса;
	
	// 3. готовим макет 
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	Макет = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиКомпоновкиДанных, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	// 4. исполняем макет 
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(Макет);
	ПроцессорКомпоновки.Сбросить();
	
	// 5. выводим результат 
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(ДобавляемыеСтроки);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(ДобавляемыеСтроки);
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьЗависимыеВидыЦен(ВидЦен)
	Перем ДеревоРезультата;
	
	МассивВидовЦен = Новый Массив;
	МассивВидовЦен.Добавить(ВидЦен);
	
	Обработки.Ценообразование.ПолучитьДеревоВидовЦен(ДеревоРезультата, МассивВидовЦен, Истина, Ложь);
	
	ВыбранныеВидыЦен = Новый Соответствие;
	
	Для каждого ГруппаВидовЦен Из ДеревоРезультата.Строки Цикл
		
		СтрокиБазовыхВидовЦен = ГруппаВидовЦен.Строки;
		Для каждого СтрокаБазовогоВидаЦен Из СтрокиБазовыхВидовЦен Цикл
			
			Если НЕ СтрокаБазовогоВидаЦен.Использование Тогда
				
				Продолжить;
				
			КонецЕсли;
			
			ПодчиненныеВидыЦен		= Новый Массив;
			СтрокиРасчетныхВидовЦен = СтрокаБазовогоВидаЦен.Строки;
			Для каждого СтрокаВидаЦен Из СтрокиРасчетныхВидовЦен Цикл
				
				ПодчиненныеВидыЦен.Добавить(СтрокаВидаЦен.ВидЦен);
				
			КонецЦикла;
			
			ВыбранныеВидыЦен.Вставить(СтрокаБазовогоВидаЦен.ВидЦен, ПодчиненныеВидыЦен);
			
		КонецЦикла;
		
	КонецЦикла;
	
	Возврат ВыбранныеВидыЦен;
	
КонецФункции

&НаСервере
Функция ЗаполнитьПараметрыОткрытияНаСервере(ВидЦен)
	
	ВыбранныеВидыЦен = ЗаполнитьЗависимыеВидыЦен(ВидЦен);
	
	Запрос = Новый Запрос("Выбрать Первые 1 * Из РегистрСведений.ОчередьРасчетаЦен КАК ОчередьЦен Где ОчередьЦен.ВидЦенРасчетный = &ВидЦен");
	Запрос.УстановитьПараметр("ВидЦен", ВидЦен);
	ЦеныАктуальны = Запрос.Выполнить().Пустой();
	
	ДанныеВидаЦен = Новый Структура;
	ДанныеВидаЦен.Вставить("ТипВидаЦен",			ВидЦен.ТипВидаЦен);
	ДанныеВидаЦен.Вставить("ВыбранныеВидыЦен",		ВыбранныеВидыЦен);
	ДанныеВидаЦен.Вставить("РассчитыватьАвтоматически", ВидЦен.РассчитыватьАвтоматически);
	ДанныеВидаЦен.Вставить("ЦеныАктуальны",			ВидЦен.ЦеныАктуальны);
	
	Возврат ДанныеВидаЦен;
	
КонецФункции

&НаКлиенте
Процедура СформироватьЦены(ВидЦен)
	Перем ОписаниеОшибки;
	
	Если НЕ ЗначениеЗаполнено(ВидЦен) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ДанныеВидаЦен = ЗаполнитьПараметрыОткрытияНаСервере(ВидЦен);
	
	Если ДанныеВидаЦен.ТипВидаЦен = КэшЗначений.Статический Тогда
		
		МассивВидовЦен = Новый Массив;
		МассивВидовЦен.Добавить(ВидЦен);
		
		АдресВременногоХранилища = "";
		ПолучитьНоменклатуруСЦеной(МассивВидовЦен, АдресВременногоХранилища);
		
		ПараметрыОткрытия = Новый Структура("ВыбранныеВидыЦен, АдресВременногоХранилища", ДанныеВидаЦен.ВыбранныеВидыЦен, АдресВременногоХранилища);
		ОткрытьФорму("Обработка.Ценообразование.Форма", ПараметрыОткрытия, ЭтаФорма);
		
	ИначеЕсли НЕ ДанныеВидаЦен.РассчитыватьАвтоматически Тогда
		
		Если ДанныеВидаЦен.ЦеныАктуальны Тогда
			
			ТекстСообщения = НСтр("ru ='Цены по колонке прайс-листа актуальны. Расчет не требуется.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, ВидЦен, "Список");
			
		Иначе
			
			ПараметрыОткрытия = Новый Структура("ВидЦен", ВидЦен);
			
			ОткрытьФорму("Обработка.Ценообразование.Форма.РасчетныеЦены", ПараметрыОткрытия, ЭтаФорма);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#Область БыстрыйОтбор

&НаСервере
Процедура ПрочитатьПрайсЛисты()
	
	Запрос = Новый Запрос("Выбрать Ложь КАК Флаг, ПЛ.Ссылка КАК ПрайсЛист Из Справочник.ПрайсЛисты КАК ПЛ Где НЕ ПЛ.ПометкаУдаления");
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		
		Элементы.ОтборПрайсЛисты.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСверху;
		
	Иначе
		
		ЗначениеВРеквизитФормы(РезультатЗапроса.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией), "ОтборПрайсЛисты");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборПрайсЛистыФлагПриИзменении(Элемент)
	
	ТекущаяСтрокаДерева = ОтборПрайсЛисты.НайтиПоИдентификатору(Элементы.ОтборПрайсЛисты.ТекущиеДанные.ПолучитьИдентификатор());
	УстановитьФлагУПодчиненных(ТекущаяСтрокаДерева.ПолучитьЭлементы(), ТекущаяСтрокаДерева.Флаг);
	
	ПрайсЛисты	= НайтиВыбранныеСтроки(ОтборПрайсЛисты.ПолучитьЭлементы());
	ВидыЦен		= ВидыЦенПрайсЛистов(ПрайсЛисты);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Ссылка", ВидыЦен, ВидСравненияКомпоновкиДанных.ВСписке, , (ВидыЦен.Количество() > 0));
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьФлагУПодчиненных(СписокЭлементов, Флаг)
	
	Для Каждого СтрокаДерева Из СписокЭлементов Цикл
		
		СтрокаДерева.Флаг = Флаг;
		
		ДочерниеСтроки = СтрокаДерева.ПолучитьЭлементы();
		Если ДочерниеСтроки.Количество() > 0 Тогда
			
			УстановитьФлагУПодчиненных(ДочерниеСтроки, Флаг);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция НайтиВыбранныеСтроки(СписокЭлементов)
	
	ПрайсЛисты = Новый Массив;
	Для Каждого СтрокаДерева Из СписокЭлементов Цикл
		
		Если СтрокаДерева.Флаг Тогда
			
			ПрайсЛисты.Добавить(СтрокаДерева.ПрайсЛист);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПрайсЛисты;
	
КонецФункции

&НаСервере
Функция ВидыЦенПрайсЛистов(ПрайсЛисты)
	
	Запрос = Новый Запрос("Выбрать различные ВидыЦен.ВидЦен КАК ВидЦен Из Справочник.ПрайсЛисты.ВидыЦен КАК ВидыЦен Где ВидыЦен.Ссылка В(&ПрайсЛисты)");
	Запрос.УстановитьПараметр("ПрайсЛисты", ПрайсЛисты);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ВидЦен");
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СобытияФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка доступности цен для редактирования.
	РазрешеноРедактированиеЦенДокументов = УправлениеНебольшойФирмойУправлениеДоступомПовтИсп.РазрешеноРедактированиеЦенДокументов();
	
	Элементы.Список.ТолькоПросмотр = НЕ РазрешеноРедактированиеЦенДокументов;
	Элементы.СформироватьЦены.Видимость = РазрешеноРедактированиеЦенДокументов;
	
	// Выделение основного элемента	
	УправлениеНебольшойФирмойСервер.ВыделитьЖирнымОсновнойЭлемент(УправлениеНебольшойФирмойПовтИсп.ПолучитьЗначениеНастройки("ОсновнойВидЦенПродажи"), Список);
	
	КэшЗначений = Новый Структура;
	КэшЗначений.Вставить("Статический",			Перечисления.ТипыВидовЦен.Статический);
	КэшЗначений.Вставить("ДинамическийПроцент", Перечисления.ТипыВидовЦен.ДинамическийПроцент);
	КэшЗначений.Вставить("ДинамическийФормула", Перечисления.ТипыВидовЦен.ДинамическийФормула);
	КэшЗначений.Вставить("ЭтоЗагрузкаИзВнешнегоИсточника", Неопределено);
	
	Параметры.Свойство("ЭтоЗагрузкаИзВнешнегоИсточника", КэшЗначений.ЭтоЗагрузкаИзВнешнегоИсточника);
	
	ПараметрыДлительнойОперации = Новый Структура;
	ПараметрыДлительнойОперации.Вставить("ЗаданиеВыполнено", Неопределено);
	ПараметрыДлительнойОперации.Вставить("ПараметрыОбработчика", Неопределено);
	ПараметрыДлительнойОперации.Вставить("ИдентификаторЗадания", "");
	
	ПрочитатьПрайсЛисты();
	
	// СтандартныеПодсистемы.ЗагрузкаДанныхИзВнешнегоИсточника
	ЗагрузкаДанныхИзВнешнегоИсточника.ПриСозданииНаСервере(Метаданные.РегистрыСведений.ЦеныНоменклатуры, НастройкиЗагрузкиДанных, ЭтотОбъект, Ложь);
	// Конец СтандартныеПодсистемы.ЗагрузкаДанныхИзВнешнегоИсточника
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если КэшЗначений.ЭтоЗагрузкаИзВнешнегоИсточника = Истина Тогда
		
		ПодключитьОбработчикОжидания("ПоказатьПомощникЗагрузкиДанныхИзВнешнегоИсточника", 0.2, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Процедура - обработчик события ОбработкаОповещения
//
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписьРасчетныхЦен" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиРеквизитовФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.СформироватьЦены Тогда
		
		СтандартнаяОбработка = Ложь;
		СформироватьЦены(ВыбраннаяСтрока);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ДанныеТекущейстроки = Элементы.Список.ТекущиеДанные;
	Если ДанныеТекущейстроки <> Неопределено Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДекорацияПредупреждение", "Видимость", ДанныеТекущейстроки.ПоказатьПредупреждение);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
// Процедура - обработчик выполнения команды УстановитьОсновнойЭлемент
//
Процедура КомандаУстановитьОсновнойЭлемент(Команда)
		
	ВыбранныйЭлемент = Элементы.Список.ТекущаяСтрока;
	Если ЗначениеЗаполнено(ВыбранныйЭлемент) Тогда
		УстановитьОсновнойЭлемент(ВыбранныйЭлемент);	
	КонецЕсли; 
	
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

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла
&НаКлиенте
Процедура ПоказатьПомощникЗагрузкиДанныхИзВнешнегоИсточника()
	
	ДанныеТекущейСтроки = Элементы.Список.ТекущиеДанные;
	Если ЗначениеЗаполнено(ДанныеТекущейСтроки.Ссылка) Тогда
		
		НастройкиЗагрузкиДанных.Вставить("ОбщееЗначение", ДанныеТекущейСтроки.Ссылка);
		
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузкаДанныхИзВнешнегоИсточникаОбработкаРезультата", ЭтотОбъект, НастройкиЗагрузкиДанных);
	
	ЗагрузкаДанныхИзВнешнегоИсточникаКлиент.ПоказатьФормуЗагрузкиДанныхИзВнешнегоИсточника(НастройкиЗагрузкиДанных, ОписаниеОповещения, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьЦеныИзВнешнегоИсточника(Команда)
	
	ДанныеТекущейСтроки = Элементы.Список.ТекущиеДанные;
	Если ДанныеТекущейСтроки <> Неопределено
		И ДанныеТекущейСтроки.ТипВидаЦен <> КэшЗначений.Статический Тогда
		
		ТекстСообщения = НСтр("ru ='Загрузка предназначена только для статических видов цен.'");
		ПоказатьПредупреждение(Неопределено, ТекстСообщения, 15, НСтр("ru ='Загрузить цены из внешнего источника'"));
		Возврат;
		
	КонецЕсли;
	
	ПоказатьПомощникЗагрузкиДанныхИзВнешнегоИсточника();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаДанныхИзВнешнегоИсточникаОбработкаРезультата(РезультатЗагрузки, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатЗагрузки) = Тип("Структура") Тогда
		
		Если РезультатЗагрузки.ОписаниеДействия = "ИзменитьСпособЗагрузкиДанныхИзВнешнегоИсточника" Тогда
		
			ЗагрузкаДанныхИзВнешнегоИсточника.ИзменитьСпособЗагрузкиДанныхИзВнешнегоИсточника(НастройкиЗагрузкиДанных.ИмяФормыЗагрузкиДанныхИзВнешнихИсточников);
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузкаДанныхИзВнешнегоИсточникаОбработкаРезультата", ЭтотОбъект, НастройкиЗагрузкиДанных);
			ЗагрузкаДанныхИзВнешнегоИсточникаКлиент.ПоказатьФормуЗагрузкиДанныхИзВнешнегоИсточника(НастройкиЗагрузкиДанных, ОписаниеОповещения, ЭтотОбъект);
			
		ИначеЕсли РезультатЗагрузки.ОписаниеДействия = "ОбработатьПодготовленныеДанные" Тогда
			
			ОбработатьПодготовленныеДанные(РезультатЗагрузки);
			ПроверитьНеобходимостьПодключенияОбработчикаОжидания();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПодготовленныеДанные(РезультатЗагрузки)
	
	ПараметрыВызоваСервера = Новый Структура;
	ПараметрыВызоваСервера.Вставить("НастройкиЗагрузкиДанных", РезультатЗагрузки.НастройкиЗагрузкиДанных);
	ПараметрыВызоваСервера.Вставить("ТаблицаСопоставленияДанных", ДанныеФормыВЗначение(РезультатЗагрузки.ТаблицаСопоставленияДанных, Тип("ТаблицаЗначений")));
	
	ИмяМетода = "РегистрыСведений.ЦеныНоменклатуры.ОбработатьПодготовленныеДанные";
	Описание = НСтр("ru = 'Подсистема ЗагрузкаДанныхИзВнешнегоИсточника: Выполнение серверного метода загрузки результата'");
	
	РезультатФоновогоЗадания = ДлительныеОперации.ЗапуститьВыполнениеВФоне(УникальныйИдентификатор, ИмяМетода, ПараметрыВызоваСервера, Описание);
	ЗаполнитьЗначенияСвойств(ПараметрыДлительнойОперации, РезультатФоновогоЗадания);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла

#КонецОбласти