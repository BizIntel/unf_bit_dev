﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиОтчета.ПрограммноеИзменениеФормыОтчета = Истина;
	НастройкиВариантов["Основной"].Вставить("РежимПериода", "ЗаПериод");
	НастройкиВариантов["ОценкаСтоимостиСклада"].Вставить("РежимПериода", "НаДату");
	
	ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов);
	УстановитьТегиВариантов(НастройкиВариантов);
	ДобавитьОписанияСвязанныхПолей(НастройкиВариантов);
	
КонецПроцедуры

Процедура ОбновитьНастройкиНаФорме(НастройкиОтчета, НастройкиСКД, Форма) Экспорт
	
	ДобавитьПолеВыбораВидаЦен(НастройкиСКД, Форма);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	НастройкиОтчета = КомпоновщикНастроек.Настройки;
	ПараметрыОтчета = ОтчетыУНФ.ПараметрыФормированияОтчета(НастройкиОтчета);
	
	ОтчетыУНФ.СтандартизироватьСхему(СхемаКомпоновкиДанных);
	ОтчетыУНФ.ДобавитьВычисляемыеПоля(СхемаКомпоновкиДанных);
	
	УправлениеНебольшойФирмойОтчеты.УстановитьМакетОформленияОтчета(НастройкиОтчета);
	УправлениеНебольшойФирмойОтчеты.ВывестиЗаголовокОтчета(ПараметрыОтчета, ДокументРезультат);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	РасчетнаяТаблица 	= ПолучитьРасчетнуюТаблицу(НастройкиОтчета);
	ВнешниеНаборыДанных = Новый Структура("РасчетнаяТаблица", РасчетнаяТаблица);
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровки, Истина);
	
	// Создадим и инициализируем процессор вывода результата
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	// Обозначим начало вывода
	ПроцессорВывода.НачатьВывод();
	ТаблицаЗафиксирована = Ложь;
	
	ДокументРезультат.ФиксацияСверху = 0;
	// Основной цикл вывода отчета
	Пока Истина Цикл
		//Получим следующий элемент результата компоновки
		ЭлементРезультата = ПроцессорКомпоновки.Следующий();
		
		Если ЭлементРезультата = Неопределено Тогда
			//Следующий элемент не получен - заканчиваем цикл вывода
			Прервать;
		Иначе
			// Зафиксируем шапку
			Если  Не ТаблицаЗафиксирована 
				И ЭлементРезультата.ЗначенияПараметров.Количество() > 0 
				И ТипЗнч(КомпоновщикНастроек.Настройки.Структура[0]) <> Тип("ДиаграммаКомпоновкиДанных") Тогда
				
				ТаблицаЗафиксирована = Истина;
				ДокументРезультат.ФиксацияСверху = ДокументРезультат.ВысотаТаблицы;
				
			КонецЕсли;
			//Элемент получен - выведем его при помощи процессора вывода
			ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
		КонецЕсли;
	КонецЦикла;
	
	ПроцессорВывода.ЗакончитьВывод();
	
	ОтчетыУНФ.ОбоработатьДиаграммыТабличногоДокумента(ДокументРезультат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ДобавитьПолеВыбораВидаЦен(НастройкиСКД, Форма)
	
	ЗначениеПоУмолчанию = Справочники.ВидыЦен.Оптовая;
	Стр = Форма.ПоляНастроек.ПолучитьЭлементы().Добавить();
	Стр.Тип = "Параметр";
	Стр.Поле = "ВидЦены";
	Стр.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.ВидыЦен");
	Стр.Заголовок = НСтр("ru = 'Вид цены'");
	Стр.ВидЭлемента = "Поле";
	Стр.Реквизиты = Новый Структура;
	Стр.Элементы = Новый Структура;
	Стр.ДополнительныеПараметры = Новый Структура;
	ИмяРеквизита = "ПараметрВидЦены";
	Стр.Реквизиты.Вставить(ИмяРеквизита, ЗначениеПоУмолчанию);
	МассивРеквизитов = Новый Массив;
	Для каждого Элемент Из Стр.Реквизиты Цикл
		МассивРеквизитов.Добавить(Новый РеквизитФормы(Элемент.Ключ, Стр.ТипЗначения,, Стр.Заголовок));
	КонецЦикла; 
	Стр.Создан = Истина;
	Форма.ИзменитьРеквизиты(МассивРеквизитов);
	Форма[ИмяРеквизита] = ЗначениеПоУмолчанию;
	НастройкиСКД.ПараметрыДанных.УстановитьЗначениеПараметра(Стр.Поле, ЗначениеПоУмолчанию);
	Элемент = Форма.Элементы.Добавить(ИмяРеквизита, Тип("ПолеФормы"), Форма.Элементы.ГруппаПараметрыЭлементы);
	Элемент.Вид = ВидПоляФормы.ПолеВвода;
	Элемент.ПоложениеЗаголовка = ПоложениеЗаголовкаЭлементаФормы.Нет;
	Элемент.ПутьКДанным = ИмяРеквизита;
	Элемент.КнопкаОткрытия = Ложь;
	Элемент.КнопкаВыбора = Ложь;
	Элемент.КнопкаСоздания = Ложь;
	Элемент.БыстрыйВыбор = Истина;
	Элемент.ЦветРамки = ЦветаСтиля.НедоступныеДанныеЦвет;
	Элемент.ПодсказкаВвода = Стр.Заголовок;
	Элемент.Ширина = 23;
	Элемент.ОтображениеКнопкиВыбора = ОтображениеКнопкиВыбора.ОтображатьВПолеВвода;
	Элемент.УстановитьДействие("ПриИзменении", "Подключаемый_ПараметрПриИзменении");
	Стр.Элементы.Вставить(Элемент.Имя, Элемент.ПутьКДанным);

КонецПроцедуры

// Формируем таблицу остатков и движений 
//
Функция ПолучитьРасчетнуюТаблицу(НастройкиОтчета)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ВидЦены", НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ВидЦены").Значение);
	Запрос.УстановитьПараметр("НачалоПериода",	НастройкиОтчета.ПараметрыДанных.Элементы.Найти("СтПериод").Значение.ДатаНачала);
	Запрос.УстановитьПараметр("КонецПериода",	НастройкиОтчета.ПараметрыДанных.Элементы.Найти("СтПериод").Значение.ДатаОкончания);
	Запрос.УстановитьПараметр("КонецТекущегоДня",	КонецДня(ТекущаяДатаСеанса()));
	
	//Т.к. в базе могут присутствовать документы зарегистрированные одним моментом времени
	//добавляем дополнительный обход цикла с расстановкой порядка документов.
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ЗапасыОстаткиИОбороты.ПериодСекунда КАК ПериодСекунда,
	|	ЗапасыОстаткиИОбороты.Регистратор КАК Регистратор,
	|	ЗапасыОстаткиИОбороты.Номенклатура КАК Номенклатура,
	|	ЗапасыОстаткиИОбороты.Характеристика КАК Характеристика,
	|	ЗапасыОстаткиИОбороты.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ЕСТЬNULL(ЗапасыОстаткиИОбороты.КоличествоНачальныйОстаток, 0) КАК КоличествоНачальныйОстаток,
	|	ЕСТЬNULL(ЗапасыОстаткиИОбороты.КоличествоПриход, 0) КАК КоличествоПриход,
	|	ЕСТЬNULL(ЗапасыОстаткиИОбороты.КоличествоРасход, 0) КАК КоличествоРасход,
	|	ЕСТЬNULL(ЗапасыОстаткиИОбороты.КоличествоКонечныйОстаток, 0) КАК КоличествоКонечныйОстаток,
	|	ЗапасыОстаткиИОбороты.Регистратор.МоментВремени КАК РегистраторМоментВремени,
	|	0 КАК Порядок,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(ЗапасыОстаткиИОбороты.КоличествоКонечныйОстаток, 0) = 0
	|			ТОГДА 0
	|		ИНАЧЕ ЗапасыОстаткиИОбороты.СуммаКонечныйОстаток / ЗапасыОстаткиИОбороты.КоличествоКонечныйОстаток
	|	КОНЕЦ КАК СтоимостьЕдиницы
	|ИЗ
	|	РегистрНакопления.Запасы.ОстаткиИОбороты(
	|			&НачалоПериода,
	|			&КонецПериода,
	|			АВТО,
	|			,
	|			СчетУчета.ТипСчета = ЗНАЧЕНИЕ(Перечисление.ТипыСчетов.Запасы)
	|				И (Партия = ЗНАЧЕНИЕ(Справочник.ПартииНоменклатуры.ПустаяСсылка)
	|					ИЛИ Партия.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыПартий.СобственныеЗапасы))
	|				И ТИПЗНАЧЕНИЯ(СтруктурнаяЕдиница) = ТИП(Справочник.СтруктурныеЕдиницы)) КАК ЗапасыОстаткиИОбороты
	|
	|УПОРЯДОЧИТЬ ПО
	|	РегистраторМоментВремени";
	
	ТаблицаДвиженийЗапасов = Запрос.Выполнить().Выгрузить();
	
	Для каждого ДвижениеЗапаса Из ТаблицаДвиженийЗапасов Цикл
		
		ДвижениеЗапаса.Порядок = ТаблицаДвиженийЗапасов.Индекс(ДвижениеЗапаса) + 1;
		
	КонецЦикла;
	
	Запрос.Текст					= 
	"ВЫБРАТЬ
	|	ЗапасыНаСкладах.ПериодСекунда КАК Период,
	|	ЗапасыНаСкладах.Регистратор КАК Регистратор,
	|	ЗапасыНаСкладах.Номенклатура КАК Номенклатура,
	|	ЗапасыНаСкладах.Характеристика КАК Характеристика,
	|	ЗапасыНаСкладах.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ЗапасыНаСкладах.КоличествоНачальныйОстаток,
	|	ЗапасыНаСкладах.КоличествоПриход,
	|	ЗапасыНаСкладах.КоличествоРасход,
	|	ЗапасыНаСкладах.КоличествоКонечныйОстаток,
	|	ЗапасыНаСкладах.Порядок,
	|	ЗапасыНаСкладах.СтоимостьЕдиницы
	|ПОМЕСТИТЬ ОстаткиИОбороты
	|ИЗ
	|	&ОстаткиИОбороты КАК ЗапасыНаСкладах
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	НАЧАЛОПЕРИОДА(ТаблицаЦен.Период, ДЕНЬ) КАК Период,
	|	ТаблицаЦен.Регистратор,
	|	ТаблицаЦен.Номенклатура,
	|	ТаблицаЦен.Характеристика,
	|	ЦеныНоменклатурыАктуальная.Цена,
	|	ЕСТЬNULL(ЦеныНоменклатурыПредыдущая.Цена, 0) КАК СтараяЦена,
	|	ЦеныНоменклатурыАктуальная.Цена - ЕСТЬNULL(ЦеныНоменклатурыПредыдущая.Цена, 0) КАК Дельта
	|ПОМЕСТИТЬ ИзмененияЦен
	|ИЗ
	|	(ВЫБРАТЬ
	|		АктуальныеЦены.Период КАК Период,
	|		МАКСИМУМ(ЦеныДоИзменения.Период) КАК ДатаПрошлогоИзменения,
	|		""Изменение цены"" КАК Регистратор,
	|		АктуальныеЦены.ВидЦен КАК ВидЦен,
	|		АктуальныеЦены.Номенклатура КАК Номенклатура,
	|		АктуальныеЦены.Характеристика КАК Характеристика
	|	ИЗ
	|		РегистрСведений.ЦеныНоменклатуры КАК АктуальныеЦены
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры КАК ЦеныДоИзменения
	|			ПО АктуальныеЦены.Номенклатура = ЦеныДоИзменения.Номенклатура
	|				И АктуальныеЦены.Характеристика = ЦеныДоИзменения.Характеристика
	|				И (ЦеныДоИзменения.ВидЦен = &ВидЦены)
	|				И АктуальныеЦены.Период > ЦеныДоИзменения.Период
	|	ГДЕ
	|		АктуальныеЦены.ВидЦен = &ВидЦены
	|	
	|	СГРУППИРОВАТЬ ПО
	|		АктуальныеЦены.ВидЦен,
	|		АктуальныеЦены.Номенклатура,
	|		АктуальныеЦены.Характеристика,
	|		АктуальныеЦены.Период) КАК ТаблицаЦен
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры КАК ЦеныНоменклатурыАктуальная
	|		ПО ТаблицаЦен.Период = ЦеныНоменклатурыАктуальная.Период
	|			И ТаблицаЦен.ВидЦен = ЦеныНоменклатурыАктуальная.ВидЦен
	|			И ТаблицаЦен.Номенклатура = ЦеныНоменклатурыАктуальная.Номенклатура
	|			И ТаблицаЦен.Характеристика = ЦеныНоменклатурыАктуальная.Характеристика
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры КАК ЦеныНоменклатурыПредыдущая
	|		ПО ТаблицаЦен.ДатаПрошлогоИзменения = ЦеныНоменклатурыПредыдущая.Период
	|			И ТаблицаЦен.ВидЦен = ЦеныНоменклатурыПредыдущая.ВидЦен
	|			И ТаблицаЦен.Номенклатура = ЦеныНоменклатурыПредыдущая.Номенклатура
	|			И ТаблицаЦен.Характеристика = ЦеныНоменклатурыПредыдущая.Характеристика
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВидыЦен.ВалютаЦены КАК Валюта,
	|	ТаблицаЗапасыНаСкладахМаксимальныйПериод.ПериодДвижения КАК ПериодСекунда,
	|	НАЧАЛОПЕРИОДА(ТаблицаЗапасыНаСкладахМаксимальныйПериод.ПериодДвижения, МИНУТА) КАК ПериодМинута,
	|	НАЧАЛОПЕРИОДА(ТаблицаЗапасыНаСкладахМаксимальныйПериод.ПериодДвижения, ЧАС) КАК ПериодЧас,
	|	НАЧАЛОПЕРИОДА(ТаблицаЗапасыНаСкладахМаксимальныйПериод.ПериодДвижения, ДЕНЬ) КАК ПериодДень,
	|	НАЧАЛОПЕРИОДА(ТаблицаЗапасыНаСкладахМаксимальныйПериод.ПериодДвижения, НЕДЕЛЯ) КАК ПериодНеделя,
	|	НАЧАЛОПЕРИОДА(ТаблицаЗапасыНаСкладахМаксимальныйПериод.ПериодДвижения, МЕСЯЦ) КАК ПериодМесяц,
	|	НАЧАЛОПЕРИОДА(ТаблицаЗапасыНаСкладахМаксимальныйПериод.ПериодДвижения, КВАРТАЛ) КАК ПериодКвартал,
	|	НАЧАЛОПЕРИОДА(ТаблицаЗапасыНаСкладахМаксимальныйПериод.ПериодДвижения, ГОД) КАК ПериодГод,
	|	ТаблицаЗапасыНаСкладахМаксимальныйПериод.Регистратор,
	|	ТаблицаЗапасыНаСкладахМаксимальныйПериод.СтруктурнаяЕдиница,
	|	ТаблицаЗапасыНаСкладахМаксимальныйПериод.Номенклатура,
	|	ТаблицаЗапасыНаСкладахМаксимальныйПериод.Характеристика,
	|	ТаблицаЗапасыНаСкладахМаксимальныйПериод.КоличествоНачальныйОстаток КАК КоличествоНачальныйОстаток,
	|	ТаблицаЗапасыНаСкладахМаксимальныйПериод.КоличествоПриход КАК КоличествоПриход,
	|	ТаблицаЗапасыНаСкладахМаксимальныйПериод.КоличествоРасход КАК КоличествоРасход,
	|	ТаблицаЗапасыНаСкладахМаксимальныйПериод.КоличествоКонечныйОстаток КАК КоличествоКонечныйОстаток,
	|	ТаблицаЗапасыНаСкладахМаксимальныйПериод.КоличествоНачальныйОстаток * ЦеныНоменклатуры.Цена КАК СуммаНачальныйОстаток,
	|	ТаблицаЗапасыНаСкладахМаксимальныйПериод.КоличествоПриход * ЦеныНоменклатуры.Цена КАК СуммаПриход,
	|	ТаблицаЗапасыНаСкладахМаксимальныйПериод.КоличествоРасход * ЦеныНоменклатуры.Цена КАК СуммаРасход,
	|	ТаблицаЗапасыНаСкладахМаксимальныйПериод.КоличествоКонечныйОстаток * ЦеныНоменклатуры.Цена КАК СуммаКонечныйОстаток,
	|	ТаблицаЗапасыНаСкладахМаксимальныйПериод.Порядок КАК Порядок,
	|	ТаблицаЗапасыНаСкладахМаксимальныйПериод.ПериодДвижения КАК ДатаРегистрации,
	|	ЦеныНоменклатуры.Цена КАК ТекущаяЦена,
	|	ТаблицаЗапасыНаСкладахМаксимальныйПериод.СтоимостьЕдиницы
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗапасыНаСкладах.Период КАК ПериодДвижения,
	|		ЗапасыНаСкладах.Регистратор КАК Регистратор,
	|		ЗапасыНаСкладах.Номенклатура КАК Номенклатура,
	|		ЗапасыНаСкладах.Характеристика КАК Характеристика,
	|		ЗапасыНаСкладах.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|		ЗапасыНаСкладах.КоличествоНачальныйОстаток КАК КоличествоНачальныйОстаток,
	|		ЗапасыНаСкладах.КоличествоПриход КАК КоличествоПриход,
	|		ЗапасыНаСкладах.КоличествоРасход КАК КоличествоРасход,
	|		ЗапасыНаСкладах.КоличествоКонечныйОстаток КАК КоличествоКонечныйОстаток,
	|		ЗапасыНаСкладах.Порядок КАК Порядок,
	|		МАКСИМУМ(ЦеныНоменклатуры.Период) КАК ПериодМаксимум,
	|		ЗапасыНаСкладах.СтоимостьЕдиницы КАК СтоимостьЕдиницы
	|	ИЗ
	|		ОстаткиИОбороты КАК ЗапасыНаСкладах
	|			ЛЕВОЕ СОЕДИНЕНИЕ ИзмененияЦен КАК ЦеныНоменклатуры
	|			ПО ЗапасыНаСкладах.Номенклатура = ЦеныНоменклатуры.Номенклатура
	|				И ЗапасыНаСкладах.Характеристика = ЦеныНоменклатуры.Характеристика
	|				И ЗапасыНаСкладах.Период >= ЦеныНоменклатуры.Период
	|	{ГДЕ
	|		ЗапасыНаСкладах.Номенклатура,
	|		ЗапасыНаСкладах.Характеристика}
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ЗапасыНаСкладах.Период,
	|		ЗапасыНаСкладах.Регистратор,
	|		ЗапасыНаСкладах.Номенклатура,
	|		ЗапасыНаСкладах.Характеристика,
	|		ЗапасыНаСкладах.СтруктурнаяЕдиница,
	|		ЗапасыНаСкладах.КоличествоНачальныйОстаток,
	|		ЗапасыНаСкладах.КоличествоПриход,
	|		ЗапасыНаСкладах.КоличествоРасход,
	|		ЗапасыНаСкладах.КоличествоКонечныйОстаток,
	|		ЗапасыНаСкладах.Порядок,
	|		ЗапасыНаСкладах.СтоимостьЕдиницы) КАК ТаблицаЗапасыНаСкладахМаксимальныйПериод
	|		ЛЕВОЕ СОЕДИНЕНИЕ ИзмененияЦен КАК ЦеныНоменклатуры
	|		ПО ТаблицаЗапасыНаСкладахМаксимальныйПериод.Номенклатура = ЦеныНоменклатуры.Номенклатура
	|			И ТаблицаЗапасыНаСкладахМаксимальныйПериод.Характеристика = ЦеныНоменклатуры.Характеристика
	|			И ТаблицаЗапасыНаСкладахМаксимальныйПериод.ПериодМаксимум = ЦеныНоменклатуры.Период
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыЦен КАК ВидыЦен
	|		ПО (ВидыЦен.Ссылка = &ВидЦены)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВидыЦен.ВалютаЦены,
	|	БлижайшиеОстаткиПоНоменклатуре.Период,
	|	НАЧАЛОПЕРИОДА(БлижайшиеОстаткиПоНоменклатуре.Период, МИНУТА),
	|	НАЧАЛОПЕРИОДА(БлижайшиеОстаткиПоНоменклатуре.Период, ЧАС),
	|	НАЧАЛОПЕРИОДА(БлижайшиеОстаткиПоНоменклатуре.Период, ДЕНЬ),
	|	НАЧАЛОПЕРИОДА(БлижайшиеОстаткиПоНоменклатуре.Период, НЕДЕЛЯ),
	|	НАЧАЛОПЕРИОДА(БлижайшиеОстаткиПоНоменклатуре.Период, МЕСЯЦ),
	|	НАЧАЛОПЕРИОДА(БлижайшиеОстаткиПоНоменклатуре.Период, КВАРТАЛ),
	|	НАЧАЛОПЕРИОДА(БлижайшиеОстаткиПоНоменклатуре.Период, ГОД),
	|	БлижайшиеОстаткиПоНоменклатуре.Регистратор,
	|	БлижайшиеОстаткиПоНоменклатуре.СтруктурнаяЕдиница,
	|	БлижайшиеОстаткиПоНоменклатуре.Номенклатура,
	|	БлижайшиеОстаткиПоНоменклатуре.Характеристика,
	|	ЕСТЬNULL(ЗапасыНаСкладахОстаткиИОбороты.КоличествоКонечныйОстаток, 0),
	|	0,
	|	0,
	|	ЕСТЬNULL(ЗапасыНаСкладахОстаткиИОбороты.КоличествоКонечныйОстаток, 0),
	|	ЕСТЬNULL(ЗапасыНаСкладахОстаткиИОбороты.КоличествоКонечныйОстаток * БлижайшиеОстаткиПоНоменклатуре.СтараяЦена, 0),
	|	ВЫБОР
	|		КОГДА БлижайшиеОстаткиПоНоменклатуре.Дельта > 0
	|			ТОГДА ЕСТЬNULL(ЗапасыНаСкладахОстаткиИОбороты.КоличествоКонечныйОстаток * БлижайшиеОстаткиПоНоменклатуре.Дельта, 0)
	|		ИНАЧЕ 0
	|	КОНЕЦ,
	|	ВЫБОР
	|		КОГДА БлижайшиеОстаткиПоНоменклатуре.Дельта < 0
	|			ТОГДА ЕСТЬNULL(-ЗапасыНаСкладахОстаткиИОбороты.КоличествоКонечныйОстаток * БлижайшиеОстаткиПоНоменклатуре.Дельта, 0)
	|		ИНАЧЕ 0
	|	КОНЕЦ,
	|	ЕСТЬNULL(ЗапасыНаСкладахОстаткиИОбороты.КоличествоКонечныйОстаток * БлижайшиеОстаткиПоНоменклатуре.Цена, 0),
	|	БлижайшиеОстаткиПоНоменклатуре.Порядок,
	|	БлижайшиеОстаткиПоНоменклатуре.Период,
	|	БлижайшиеОстаткиПоНоменклатуре.Цена,
	|	БлижайшиеОстаткиПоНоменклатуре.СтоимостьЕдиницы
	|ИЗ
	|	(ВЫБРАТЬ
	|		ИзмененияЦен.Период КАК Период,
	|		ИзмененияЦен.Дельта КАК Дельта,
	|		ИзмененияЦен.Цена КАК Цена,
	|		ИзмененияЦен.СтараяЦена КАК СтараяЦена,
	|		ИзмененияЦен.Номенклатура КАК Номенклатура,
	|		ИзмененияЦен.Характеристика КАК Характеристика,
	|		ЗапасыНаСкладахОстаткиИОбороты.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|		МАКСИМУМ(ЗапасыНаСкладахОстаткиИОбороты.Порядок) КАК Порядок,
	|		ИзмененияЦен.Регистратор КАК Регистратор,
	|		ЗапасыНаСкладахОстаткиИОбороты.СтоимостьЕдиницы КАК СтоимостьЕдиницы
	|	ИЗ
	|		ИзмененияЦен КАК ИзмененияЦен
	|			ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиИОбороты КАК ЗапасыНаСкладахОстаткиИОбороты
	|			ПО ИзмененияЦен.Номенклатура = ЗапасыНаСкладахОстаткиИОбороты.Номенклатура
	|				И ИзмененияЦен.Характеристика = ЗапасыНаСкладахОстаткиИОбороты.Характеристика
	|				И ИзмененияЦен.Период > ЗапасыНаСкладахОстаткиИОбороты.Период
	|	ГДЕ
	|		ВЫБОР
	|				КОГДА &КонецПериода = ДАТАВРЕМЯ(1, 1, 1)
	|					ТОГДА ИзмененияЦен.Период <= &КонецТекущегоДня
	|				ИНАЧЕ ИзмененияЦен.Период <= &КонецПериода
	|			КОНЕЦ
	|	{ГДЕ
	|		ИзмененияЦен.Номенклатура.*,
	|		ИзмененияЦен.Характеристика.*}
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ИзмененияЦен.Номенклатура,
	|		ЗапасыНаСкладахОстаткиИОбороты.СтруктурнаяЕдиница,
	|		ИзмененияЦен.Характеристика,
	|		ИзмененияЦен.Дельта,
	|		ИзмененияЦен.Цена,
	|		ИзмененияЦен.СтараяЦена,
	|		ИзмененияЦен.Период,
	|		ИзмененияЦен.Регистратор,
	|		ЗапасыНаСкладахОстаткиИОбороты.СтоимостьЕдиницы) КАК БлижайшиеОстаткиПоНоменклатуре
	|		ЛЕВОЕ СОЕДИНЕНИЕ ОстаткиИОбороты КАК ЗапасыНаСкладахОстаткиИОбороты
	|		ПО БлижайшиеОстаткиПоНоменклатуре.Номенклатура = ЗапасыНаСкладахОстаткиИОбороты.Номенклатура
	|			И БлижайшиеОстаткиПоНоменклатуре.Характеристика = ЗапасыНаСкладахОстаткиИОбороты.Характеристика
	|			И БлижайшиеОстаткиПоНоменклатуре.СтруктурнаяЕдиница = ЗапасыНаСкладахОстаткиИОбороты.СтруктурнаяЕдиница
	|			И БлижайшиеОстаткиПоНоменклатуре.Порядок = ЗапасыНаСкладахОстаткиИОбороты.Порядок
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ВидыЦен КАК ВидыЦен
	|		ПО (ВидыЦен.Ссылка = &ВидЦены)
	|ГДЕ
	|	БлижайшиеОстаткиПоНоменклатуре.Порядок > 0
	|	И ЗапасыНаСкладахОстаткиИОбороты.Порядок > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок";
	
	Запрос.УстановитьПараметр("ОстаткиИОбороты", 	ТаблицаДвиженийЗапасов);
	
	РасчетнаяТаблица = Запрос.Выполнить().Выгрузить();
	
	Возврат РасчетнаяТаблица;
	
КонецФункции //ПолучитьРасчетнуюТаблицу()

Процедура ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов)
	
	МассивПолейСумм = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("СуммаНачальныйОстаток,СуммаПриход,СуммаРасход,СуммаКонечныйОстаток,СтоимостьЕдиницы,ТекущаяЦена");
	МассивПолейКоличеств = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("КоличествоНачальныйОстаток,КоличествоПриход,КоличествоРасход,КоличествоКонечныйОстаток");
	
	Для каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		
		ВариантыОформления = НастройкиТекВарианта.Значение.ВариантыОформления;
		ОтчетыУНФ.ДобавитьВариантыОформленияСумм(ВариантыОформления, МассивПолейСумм);
		ОтчетыУНФ.ДобавитьВариантыОформленияКоличества(ВариантыОформления, МассивПолейКоличеств);
			
	КонецЦикла; 
	
КонецПроцедуры

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	НастройкиВариантов["Основной"].Теги = НСТР("ru = 'Запасы,Закупки,Склады,Номенклатура,Остатки,Цены'");
	НастройкиВариантов["ОценкаСтоимостиСклада"].Теги = НСтр("ru = 'Запасы,Закупки,Склады,Номенклатура,Остатки,Цены'");
	
КонецПроцедуры

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["Основной"].СвязанныеПоля, "СтруктурнаяЕдиница", "Справочник.СтруктурныеЕдиницы", Перечисления.ТипыСтруктурныхЕдиниц.Склад);
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["ОценкаСтоимостиСклада"].СвязанныеПоля, "СтруктурнаяЕдиница", "Справочник.СтруктурныеЕдиницы", Перечисления.ТипыСтруктурныхЕдиниц.Склад);
	
КонецПроцедуры
 
#КонецОбласти

ЭтоОтчетУНФ = Истина;

#КонецЕсли