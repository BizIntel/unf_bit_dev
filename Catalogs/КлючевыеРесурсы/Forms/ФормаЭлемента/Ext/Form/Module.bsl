﻿
#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриСозданииНаСервере.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗагрузитьНастройкиФормы();
	
	ЦветЗанятогоПериода = ЦветаСтиля.РабочееВремяЗанятоПолностью;
	ЦветСвободногоПериода = ЦветаСтиля.РабочееВремяСвободноДоступно;
	
	ДатаГрафика = ТекущаяДата();
	
	ОтчетыУНФ.ПриСозданииНаСервереФормыСвязанногоОбъекта(ЭтотОбъект);
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры // ПриСозданииНаСервере()

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗаполнитьПредставлениеПериода();
	СформироватьИтоги();
	
	#Если ВебКлиент Тогда
		ЭтоВебКлиент = Истина;
	#Иначе
		ЭтоВебКлиент = Ложь;
	#КонецЕсли
	
	ВывестиРасписаниеПоГрафику();
	
КонецПроцедуры // ПриОткрытии()

// Процедура - обработчик события ПослеЗаписи.
//
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_КлючевыеРесурсы");
	
КонецПроцедуры // ПослеЗаписи()

// Процедура - обработчик события ПриЗакрытии.
//
&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураНастроек = Новый Структура;
	
	СтруктураНастроек.Вставить("РасписаниеПоГрафикуПериодГодПометка", Переключатель = "Год");
	СтруктураНастроек.Вставить("РасписаниеПоГрафикуПериодДеньПометка", Переключатель = "День");
	
	СтруктураНастроек.Вставить("КратностьДня", КратностьДня);
	
	СохранитьНастройкиФормы(СтруктураНастроек);
	
КонецПроцедуры // ПриЗакрытии()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

// Процедура - обработчик события ПриАктивизацииОбласти поля РасписаниеПоГрафику.
//
&НаКлиенте
Процедура РасписаниеПоГрафикуПриАктивизацииОбласти(Элемент)
	
	График = ПолучитьТекущийГрафик();
	Элементы.График.Доступность = ЗначениеЗаполнено(График);
	Элементы.УстановитьГрафик.Доступность = ЗначениеЗаполнено(График);
	Элементы.УстановитьГрафик.Доступность = ЗначениеЗаполнено(График);
	
	Если Переключатель = "Год" И
		(РасписаниеПоГрафику.ВыделенныеОбласти.Количество() > 1
			ИЛИ (РасписаниеПоГрафику.ВыделенныеОбласти.Количество() = 1
			И (РасписаниеПоГрафику.ВыделенныеОбласти[0].Лево <> РасписаниеПоГрафику.ВыделенныеОбласти[0].Право
			ИЛИ РасписаниеПоГрафику.ВыделенныеОбласти[0].Верх <> РасписаниеПоГрафику.ВыделенныеОбласти[0].Низ))) Тогда
		Элементы.УстановитьГрафик.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры // РасписаниеПоГрафикуПриАктивизацииОбласти()

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если График = ВыбранноеЗначение Тогда
		Возврат;
	КонецЕсли;
	
	График = ВыбранноеЗначение;
	
	Если Переключатель = "Год" Тогда
		ВыделеннаяОбласть = РасписаниеПоГрафику.ВыделенныеОбласти[0];
		НомерМесяца = ВыделеннаяОбласть.Верх - 1;
		НомерДня = ВыделеннаяОбласть.Лево - 1;
		Если НомерМесяца < 1 ИЛИ НомерМесяца > 12 ИЛИ НомерДня < 1 ИЛИ НомерДня > 31 ИЛИ НомерДня > КоличествоДнейВМесяцеНаКлиенте(НомерМесяца, Год(ДатаГрафика)) Тогда
			ПоказатьПредупреждение(Неопределено,НСтр("ru='Вначале необходимо выделить день установки графика!'"));
			Возврат;
		КонецЕсли;
		УстановитьГрафикНаСервере(Дата(Год(ДатаГрафика), НомерМесяца, НомерДня, 0, 0, 0));
	Иначе
		УстановитьГрафикНаСервере(НачалоДня(ДатаГрафика));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательПриИзменении(Элемент)
	
	ЗаполнитьПредставлениеПериода();
	ВывестиРасписаниеПоГрафику();
	СформироватьИтоги();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// Процедура - обработчик нажатия кнопки ОтметитьВыбранноеКакРабочее.
//
&НаКлиенте
Процедура ОтметитьВыбранноеКакРабочее(Команда)
	
	Если Переключатель = "Год" Тогда
		ОтметитьВыбранноеКакРабочееГод();
	Иначе
		ОтметитьВыбранноеКакРабочееДень();
	КонецЕсли;
	
КонецПроцедуры // ОтметитьВыбранноеКакРабочее()

// Процедура - обработчик нажатия кнопки ОтметитьВыбранноеКакНеРабочее.
//
&НаКлиенте
Процедура ОтметитьВыбранноеКакНеРабочее(Команда)
	
	Если Переключатель = "Год" Тогда
		ОтметитьВыбранноеКакНеРабочееГод();
	Иначе
		ОтметитьВыбранноеКакНеРабочееДень();
	КонецЕсли;
	
КонецПроцедуры // ОтметитьВыбранноеКакНеРабочее()

&НаСервере
Процедура ЗаписатьРесурсНаСервере()
	
	РесурсДляЗаписи = РеквизитФормыВЗначение("Объект");
	РесурсДляЗаписи.Записать();
	ЗначениеВРеквизитФормы(РесурсДляЗаписи, "Объект");
	
Конецпроцедуры

// Процедура - обработчик нажатия кнопки УстановитьГрафик.
//
&НаКлиенте
Процедура УстановитьГрафик(Команда)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Оповещение = Новый ОписаниеОповещения("УстановитьГрафикЗавершение",ЭтаФорма);
		Режим = РежимДиалогаВопрос.ОКОтмена;
		Текст = НСтр("ru='Установка графика возможна только после записи ресурса предприятия! Ресурс будет записан.'");
		ПоказатьВопрос(Оповещение,Текст, Режим, 0);
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ГрафикиРаботы.ФормаВыбора", Новый Структура("ТекущаяСтрока", График), ЭтаФорма);
	
КонецПроцедуры // УстановитьГрафик()

&НаКлиенте
Процедура УстановитьГрафикЗавершение(Ответ,Параметры) Экспорт
	
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		ЗаписатьРесурсНаСервере();
		ОткрытьФорму("Справочник.ГрафикиРаботы.ФормаВыбора", Новый Структура("ТекущаяСтрока", График), ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик нажатия кнопки РасписаниеПоГрафикуУвеличитьПериод.
//
&НаКлиенте
Процедура РасписаниеПоГрафикуУвеличитьПериод(Команда)
	
	Если Переключатель = "Год" Тогда
		ДатаГрафика = ДобавитьМесяц(ДатаГрафика, 12);
	ИначеЕсли Переключатель = "День" Тогда
		ДатаГрафика = ДатаГрафика + 86400;
	КонецЕсли;
	
	ЗаполнитьПредставлениеПериода();
	ВывестиРасписаниеПоГрафику();
	СформироватьИтоги();
	График = ПолучитьТекущийГрафик();
	
КонецПроцедуры // РасписаниеПоГрафикуУвеличитьПериод()

// Процедура - обработчик нажатия кнопки РасписаниеПоГрафикуУменьшитьПериод.
//
&НаКлиенте
Процедура РасписаниеПоГрафикуУменьшитьПериод(Команда)
	
	Если Переключатель = "Год" Тогда
		ДатаГрафика = ДобавитьМесяц(ДатаГрафика, -12);
	ИначеЕсли Переключатель = "День" Тогда
		ДатаГрафика = ДатаГрафика - 86400;
	КонецЕсли;
	
	ЗаполнитьПредставлениеПериода();
	ВывестиРасписаниеПоГрафику();
	СформироватьИтоги();
	График = ПолучитьТекущийГрафик();
	
КонецПроцедуры // РасписаниеПоГрафикуУменьшитьПериод()

// Процедура - обработчик нажатия кнопки ОтменитьВсеИзмененияГрафика.
//
&НаКлиенте
Процедура ОтменитьВсеИзмененияГрафика(Команда)
	
	Если Переключатель = "Год" Тогда
		ОтменитьВсеИзмененияГрафикаГодНаСервере();
	Иначе
		ОтменитьВсеИзмененияГрафикаДеньНаСервере();
	КонецЕсли;
	
	СформироватьИтоги();
	
КонецПроцедуры // ОтменитьВсеИзмененияГрафика()

// Процедура - обработчик команды Настройки.
//
&НаКлиенте
Процедура Настройки(Команда)
	
	Оповещение = Новый ОписаниеОповещения("НастройкиЗавершение",ЭтаФорма);
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("КратностьДня", КратностьДня);
	ОткрытьФорму("Справочник.КлючевыеРесурсы.Форма.Настройка", СтруктураПараметров,,,,,Оповещение);
	
КонецПроцедуры // Настройки()

&НаКлиенте
Процедура НастройкиЗавершение(СтруктураВозврата,Параметры) Экспорт
	
	Если ТипЗнч(СтруктураВозврата) = Тип("Структура") И СтруктураВозврата.БылиВнесеныИзменения Тогда
		
		КратностьДня = СтруктураВозврата.КратностьДня;
		ВывестиРасписаниеПоГрафику();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура История(Команда)
	
	ОткрытьФорму("РегистрСведений.ГрафикиРаботыРесурсов.ФормаСписка",  Новый Структура("РесурсПредприятия", Объект.Ссылка), Объект.Ссылка);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура сохраняет настройки формы.
//
&НаСервереБезКонтекста
Процедура СохранитьНастройкиФормы(СтруктураНастроек)
	
	ХранилищеНастроекДанныхФорм.Сохранить("КлючевыеРесурсы", "СтруктураНастроек", СтруктураНастроек);
	
КонецПроцедуры // СохранитьНастройкиФормы()

// Процедура загружает настройки формы.
//
&НаСервере
Процедура ЗагрузитьНастройкиФормы()
	
	СтруктураНастроек = ХранилищеНастроекДанныхФорм.Загрузить("КлючевыеРесурсы", "СтруктураНастроек");
	
	Если ТипЗнч(СтруктураНастроек) = Тип("Структура") Тогда
		
		Переключатель = "Год";
		
		Если СтруктураНастроек.Свойство("РасписаниеПоГрафикуПериодДеньПометка")
			И СтруктураНастроек.РасписаниеПоГрафикуПериодДеньПометка Тогда
			Переключатель = "День";
		КонецЕсли;
		
		Если СтруктураНастроек.Свойство("КратностьДня") Тогда
			КратностьДня = СтруктураНастроек.КратностьДня;
		Иначе
			КратностьДня = 5;
		КонецЕсли;
		
	Иначе
		
		Переключатель = "Год";
		
		КратностьДня = 5;
		
	КонецЕсли;
	
КонецПроцедуры // ЗагрузитьНастройкиФормы()

// Процедура выводит расписание по графику.
//
&НаСервере
Процедура ВывестиРасписаниеПоГрафику()
	
	// Заполнение таблицы графиков для отображения текущего.
	ЗаполнитьТаблицуГрафиков();
	
	// Вывод расписания по графику в зависимости от нажатой кнопки.
	Если Переключатель = "Год" Тогда
		ВывестиРасписаниеПоГрафикуГод();
	ИначеЕсли Переключатель = "День" Тогда
		ВывестиРасписаниеПоГрафикуДень();
	КонецЕсли;
	
КонецПроцедуры // ВывестиРасписаниеПоГрафику()

// Процедура выводит расписание по графику вида Год.
//
&НаСервере
Процедура ВывестиРасписаниеПоГрафикуГод()
	
	Элементы.ВсегоРабочихДней.Видимость = Истина;
	Элементы.ВсегоНерабочихДней.Видимость = Истина;
	Элементы.ВсегоРабочихЧасов.Видимость = Истина;
	
	РасписаниеПоГрафику.Очистить();
	
	МакетРасписаниеПоГрафику = Справочники.ГрафикиРаботы.ПолучитьМакет("РасписаниеПоГрафикуГод");
	ОбластьМакета = МакетРасписаниеПоГрафику.ПолучитьОбласть("Шапка");
	РасписаниеПоГрафику.Вывести(ОбластьМакета);
	ОбластьМакета = МакетРасписаниеПоГрафику.ПолучитьОбласть("Календарь");
	РасписаниеПоГрафику.Вывести(ОбластьМакета);
	
	КоличествоСтрокВТаблице = ТаблицаГрафиков.Количество();
	
	Для НомерМесяца = 1 По 12 Цикл
		КоличествоДней = КоличествоДнейВМесяцеНаСервере(НомерМесяца, Год(ДатаГрафика));
		Для НомерДня = 1 По 31 Цикл
			Область = РасписаниеПоГрафику.Область("R" + Строка(НомерМесяца + 1) + "C" + Строка(НомерДня + 1));
			Область.Текст = "";
			Если НомерДня > КоличествоДней Тогда
				
				// Раскраска отсутствующнго дня в календаре.
				Область.ЦветФона = ЦветаСтиля.ЦветФонаФормы;
				
			Иначе
				
				ТекДата = Дата(Год(ДатаГрафика), НомерМесяца, НомерДня, 0, 0, 0);
				
				// Раскраска выходных дней.
				Если ДеньНедели(ТекДата) = 6
				 ИЛИ ДеньНедели(ТекДата) = 7 Тогда
					Если ЭтоВебКлиент Тогда
						Область.Текст = "В";
						Область.ЦветТекста = ЦветаСтиля.НерабочееВремяВыходной;
						Область.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
					Иначе
						Область.ЦветФона = ЦветаСтиля.НерабочееВремяВыходной;
					КонецЕсли;
				Иначе
					Область.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
				КонецЕсли;
				
				// Раскраска периодов относящихся к различным графикам.
				ЦветУзора = Неопределено;
				Для каждого ТекГрафик Из ТаблицаГрафиков Цикл
					Если ТекДата >= НачалоДня(ТекГрафик.Период) Тогда
						ЦветУзора = ТекГрафик.Цвет;
					КонецЕсли;
				КонецЦикла;
				
				Если ЦветУзора = Неопределено Тогда
					Если ЭтоВебКлиент Тогда
						Область.ЦветФона = ЦветаСтиля.ЦветФонаПоля;
					Иначе
						Область.Узор = ТипУзораТабличногоДокумента.БезУзора;
					КонецЕсли;
				Иначе
					Если ЭтоВебКлиент Тогда
						Область.ЦветФона = ЦветУзора;
					Иначе
						Область.Узор = ТипУзораТабличногоДокумента.Узор15;
						Область.ЦветУзора = ЦветУзора;
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
	
	// Получение расписания по графику и отклонения.
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГрафикиРаботы.ГрафикРаботы,
	|	ГрафикиРаботы.Год,
	|	ГрафикиРаботы.ВремяНачала,
	|	ГрафикиРаботы.ВремяОкончания,
	|	ГрафикиРаботы.ГрафикРаботы.Цвет КАК Цвет
	|ИЗ
	|	РегистрСведений.ГрафикиРаботы КАК ГрафикиРаботы
	|ГДЕ
	|	ГрафикиРаботы.ГрафикРаботы = &ГрафикРаботы
	|	И ГрафикиРаботы.Год = &Год
	|	И ГрафикиРаботы.ВремяНачала >= &ПериодНачало
	|	И ГрафикиРаботы.ВремяОкончания <= &ПериодКонец
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ОтклоненияОтГрафиковРаботыРесурсов.РесурсПредприятия,
	|	ОтклоненияОтГрафиковРаботыРесурсов.Год,
	|	ОтклоненияОтГрафиковРаботыРесурсов.День,
	|	ОтклоненияОтГрафиковРаботыРесурсов.ВремяНачала,
	|	ОтклоненияОтГрафиковРаботыРесурсов.ВремяОкончания,
	|	ОтклоненияОтГрафиковРаботыРесурсов.НеРабочийДень
	|ИЗ
	|	РегистрСведений.ОтклоненияОтГрафиковРаботыРесурсов КАК ОтклоненияОтГрафиковРаботыРесурсов
	|ГДЕ
	|	ОтклоненияОтГрафиковРаботыРесурсов.РесурсПредприятия = &РесурсПредприятия
	|	И ОтклоненияОтГрафиковРаботыРесурсов.ВремяНачала >= &ПериодНачало
	|	И ОтклоненияОтГрафиковРаботыРесурсов.ВремяОкончания <= &ПериодКонец";
	
	Запрос.УстановитьПараметр("Год", Год(ДатаГрафика));
	Запрос.УстановитьПараметр("РесурсПредприятия", Объект.Ссылка);
	
	Для Сч = 0 По КоличествоСтрокВТаблице - 1 Цикл
		
		ПериодНачало = НачалоДня(ТаблицаГрафиков[Сч].Период);
		
		Если Сч = КоличествоСтрокВТаблице - 1 Тогда
			ПериодКонец = КонецГода(ДатаГрафика);
		Иначе
			ПериодКонец = НачалоДня(ТаблицаГрафиков[Сч + 1].Период) - 1;
		КонецЕсли;
		
		Запрос.УстановитьПараметр("ПериодНачало", ПериодНачало);
		Запрос.УстановитьПараметр("ПериодКонец", ПериодКонец);
		Запрос.УстановитьПараметр("ГрафикРаботы", ТаблицаГрафиков[Сч].ГрафикРаботы);
		
		РезультатЗапроса = Запрос.ВыполнитьПакет();
		ДанныеГрафика = РезультатЗапроса[0].Выбрать();
		
		// Подсчет количества часов по графику.
		Пока ДанныеГрафика.Следующий() Цикл
			Значение = Окр((ДанныеГрафика.ВремяОкончания - ДанныеГрафика.ВремяНачала) / 3600);
			СтрокаТаблицы = Месяц(ДанныеГрафика.ВремяНачала) + 1;
			КолонкаТаблицы = День(ДанныеГрафика.ВремяНачала) + 1;
			Область = РасписаниеПоГрафику.Область("R" + СтрокаТаблицы + "C" + КолонкаТаблицы);
			Область.Текст = Строка(Число(?(ЗначениеЗаполнено(?(Область.Текст = "В", 0, Область.Текст)), Область.Текст, 0)) + Значение);
		КонецЦикла;
		
		// Очистка часов соответствующих дням отклонений.
		ДанныеПоОтколнениям = РезультатЗапроса[1].Выбрать();
		Пока ДанныеПоОтколнениям.Следующий() Цикл
			СтрокаТаблицы = Месяц(ДанныеПоОтколнениям.ВремяНачала) + 1;
			КолонкаТаблицы = День(ДанныеПоОтколнениям.ВремяНачала) + 1;
			Область = РасписаниеПоГрафику.Область("R" + СтрокаТаблицы + "C" + КолонкаТаблицы);
			Область.Текст = "";
		КонецЦикла;
		
		// Подсчет количества часов по отклонениям.
		ДанныеПоОтколнениям.Сбросить();
		Пока ДанныеПоОтколнениям.Следующий() Цикл
			Значение = Окр((ДанныеПоОтколнениям.ВремяОкончания - ДанныеПоОтколнениям.ВремяНачала) / 3600);
			СтрокаТаблицы = Месяц(ДанныеПоОтколнениям.ВремяНачала) + 1;
			КолонкаТаблицы = День(ДанныеПоОтколнениям.ВремяНачала) + 1;
			Область = РасписаниеПоГрафику.Область("R" + СтрокаТаблицы + "C" + КолонкаТаблицы);
			Если ДанныеПоОтколнениям.НеРабочийДень Тогда
				Значение = 0;
			Иначе
				Значение = Число(?(ЗначениеЗаполнено(Область.Текст), Область.Текст, 0)) + Значение;
			КонецЕсли;
			Область.Текст = Строка(?(Значение > 0, Значение, ""));
			Область.Примечание.Текст = "Введены отклонения.";
		КонецЦикла;
		
	КонецЦикла
	
КонецПроцедуры // ВывестиРасписаниеПоГрафикуГод()

// Процедура выводит расписание по графику вида День.
//
&НаСервере
Процедура ВывестиРасписаниеПоГрафикуДень()
	
	Элементы.ВсегоРабочихДней.Видимость = Ложь;
	Элементы.ВсегоНерабочихДней.Видимость = Ложь;
	Элементы.ВсегоРабочихЧасов.Видимость = Истина;
	
	РасписаниеПоГрафику.Очистить();
	
	МакетРасписаниеПоГрафику = Справочники.ГрафикиРаботы.ПолучитьМакет("РасписаниеПоГрафикуДень");
	ОбластьМакета = МакетРасписаниеПоГрафику.ПолучитьОбласть("Календарь" + Строка(КратностьДня));
	РасписаниеПоГрафику.Вывести(ОбластьМакета);
	
	МакетРасписаниеПоГрафику = Справочники.ГрафикиРаботы.ПолучитьМакет("РасписаниеПоГрафикуДень");
	
	// Получение данных по отклонениям на день.
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ОтклоненияОтГрафиковРаботыРесурсов.РесурсПредприятия,
	|	ОтклоненияОтГрафиковРаботыРесурсов.Год,
	|	ОтклоненияОтГрафиковРаботыРесурсов.День,
	|	ОтклоненияОтГрафиковРаботыРесурсов.ВремяНачала,
	|	ОтклоненияОтГрафиковРаботыРесурсов.ВремяОкончания,
	|	ОтклоненияОтГрафиковРаботыРесурсов.НеРабочийДень
	|ИЗ
	|	РегистрСведений.ОтклоненияОтГрафиковРаботыРесурсов КАК ОтклоненияОтГрафиковРаботыРесурсов
	|ГДЕ
	|	ОтклоненияОтГрафиковРаботыРесурсов.РесурсПредприятия = &РесурсПредприятия
	|	И ОтклоненияОтГрафиковРаботыРесурсов.День = &ПериодНачало
	|	И ОтклоненияОтГрафиковРаботыРесурсов.ВремяНачала >= &ПериодНачало
	|	И ОтклоненияОтГрафиковРаботыРесурсов.ВремяОкончания <= &ПериодКонец";
	
	Запрос.УстановитьПараметр("ПериодНачало", НачалоДня(ДатаГрафика));
	Запрос.УстановитьПараметр("ПериодКонец", КонецДня(ДатаГрафика));
	Запрос.УстановитьПараметр("РесурсПредприятия", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда // если нет отклонений до берем данные из графика
	
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ГрафикиРаботыРесурсовСрезПоследних.ГрафикРаботы КАК ГрафикРаботы
		|ПОМЕСТИТЬ ВременнаяТаблицаГрафикРаботы
		|ИЗ
		|	РегистрСведений.ГрафикиРаботыРесурсов.СрезПоследних(&ПериодКонец, РесурсПредприятия = &РесурсПредприятия) КАК ГрафикиРаботыРесурсовСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ГрафикиРаботы.ГрафикРаботы,
		|	ГрафикиРаботы.Год,
		|	ГрафикиРаботы.ВремяНачала,
		|	ГрафикиРаботы.ВремяОкончания,
		|	ГрафикиРаботы.ГрафикРаботы.Цвет КАК Цвет
		|ИЗ
		|	РегистрСведений.ГрафикиРаботы КАК ГрафикиРаботы
		|ГДЕ
		|	ГрафикиРаботы.ГрафикРаботы В
		|			(ВЫБРАТЬ
		|				ВременнаяТаблицаГрафикРаботы.ГрафикРаботы
		|			ИЗ
		|				ВременнаяТаблицаГрафикРаботы КАК ВременнаяТаблицаГрафикРаботы)
		|	И ГрафикиРаботы.Год = &Год
		|	И ГрафикиРаботы.ВремяНачала >= &ПериодНачало
		|	И ГрафикиРаботы.ВремяОкончания <= &ПериодКонец";
		
		Запрос.УстановитьПараметр("Год", Год(ДатаГрафика));
		
		РезультатЗапроса = Запрос.ВыполнитьПакет();
		
		ДанныеГрафика = РезультатЗапроса[1].Выбрать();
		
		// Раскраска рабочих периодов по графику.
		Пока ДанныеГрафика.Следующий() Цикл
			Для ТекСтрока = 1 По 4 Цикл
				Для ТекКолонка = 1 по 72 Цикл
					ТекПериодКонец = НачалоДня(ДатаГрафика) + (ТекСтрока - 1) * 72 * 300 + ТекКолонка * 300 - 1;
					ТекПериодНачало = ТекПериодКонец - 299;
					СтрокаТаблицы = ТекСтрока * 2;
					КоэфКолонкаТаблицы = ?(ТекКолонка / 12 - Окр(ТекКолонка / 12) > 0, Окр(ТекКолонка / 12 + 0.5), Окр(ТекКолонка / 12));
					КолонкаТаблицы = ТекКолонка + КоэфКолонкаТаблицы;
					Область = РасписаниеПоГрафику.Область("R" + СтрокаТаблицы + "C" + КолонкаТаблицы);
					Если ТекПериодНачало >= ДанныеГрафика.ВремяНачала
						И ТекПериодКонец <= ДанныеГрафика.ВремяОкончания Тогда
						Область.ЦветФона = ЦветаСтиля.РабочееВремяЗанятоПолностью;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
		
	Иначе // есть отклонения
		
		ДанныеПоОтклонениям = РезультатЗапроса.Выбрать();
		
		// Раскраска рабочих периодов по отклонениям.
		Пока ДанныеПоОтклонениям.Следующий() Цикл
			Если ДанныеПоОтклонениям.НеРабочийДень Тогда
				Продолжить
			КонецЕсли;
			Для ТекСтрока = 1 По 4 Цикл
				Для ТекКолонка = 1 по 72 Цикл
					ТекПериодКонец = НачалоДня(ДатаГрафика) + (ТекСтрока - 1) * 72 * 300 + ТекКолонка * 300 - 1;
					ТекПериодНачало = ТекПериодКонец - 299;
					СтрокаТаблицы = ТекСтрока * 2;
					КоэфКолонкаТаблицы = ?(ТекКолонка / 12 - Окр(ТекКолонка / 12) > 0, Окр(ТекКолонка / 12 + 0.5), Окр(ТекКолонка / 12));
					КолонкаТаблицы = ТекКолонка + КоэфКолонкаТаблицы;
					Область = РасписаниеПоГрафику.Область("R" + СтрокаТаблицы + "C" + КолонкаТаблицы);
					Если ТекПериодНачало >= ДанныеПоОтклонениям.ВремяНачала
						И ТекПериодКонец <= ДанныеПоОтклонениям.ВремяОкончания Тогда
						Область.ЦветФона = ЦветаСтиля.РабочееВремяЗанятоПолностью;
					КонецЕсли;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры // ВывестиРасписаниеПоГрафикуДень()

// Функция вычисляет количество дней в месяце.
//
&НаКлиенте
Функция КоличествоДнейВМесяцеНаКлиенте(Месяц, Год)
	
	ДатаМесяца = Дата(Год, Месяц, 1);
	ДнейВМесяце = День(КонецМесяца(ДатаМесяца));
	Возврат ДнейВМесяце;
	
КонецФункции // КоличествоДнейВМесяце()

// Функция вычисляет количество дней в месяце.
//
&НаСервере
Функция КоличествоДнейВМесяцеНаСервере(Месяц, Год)
	
	ДатаМесяца = Дата(Год, Месяц, 1);
	ДнейВМесяце = День(КонецМесяца(ДатаМесяца));
	Возврат ДнейВМесяце;
	
КонецФункции // КоличествоДнейВМесяце()

 // Процедура заполняет представление периода.
//
&НаКлиенте
Процедура ЗаполнитьПредставлениеПериода()
	
	Если Переключатель = "Год" Тогда
		РасписаниеПоГрафикуПредставлениеПериода = "" + Год(ДатаГрафика) + " год";
	ИначеЕсли Переключатель = "День" Тогда
		ДеньРасписания = Формат(ДатаГрафика, "ДФ=дд");
		МесяцРасписания = Формат(ДатаГрафика, "ДФ=МММ");
		ГодРасписания = Формат(Год(ДатаГрафика), "ЧГ=0");
		ДеньНеделиРасписания = УправлениеНебольшойФирмойКлиент.ПолучитьПредставлениеДняНедели(ДатаГрафика);
		РасписаниеПоГрафикуПредставлениеПериода = ДеньНеделиРасписания + " " + ДеньРасписания + " " + МесяцРасписания + " " + ГодРасписания;
	КонецЕсли;
	
КонецПроцедуры // ЗаполнитьПредставлениеПериода()

// Процедура заполняет таблицу графиков, которая используется для отображения
// текущего.
&НаСервере
Процедура ЗаполнитьТаблицуГрафиков()
	
	ТаблицаГрафиков.Очистить();
	
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ГрафикиРаботыРесурсов.Период КАК Период,
	|	ГрафикиРаботыРесурсов.РесурсПредприятия,
	|	ГрафикиРаботыРесурсов.ГрафикРаботы,
	|	ГрафикиРаботыРесурсов.ГрафикРаботы.Цвет КАК Цвет
	|ИЗ
	|	РегистрСведений.ГрафикиРаботыРесурсов КАК ГрафикиРаботыРесурсов
	|ГДЕ
	|	ГрафикиРаботыРесурсов.Период >= &ПериодНачало
	|	И ГрафикиРаботыРесурсов.Период <= &ПериодКонец
	|	И ГрафикиРаботыРесурсов.РесурсПредприятия = &РесурсПредприятия
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период";
	
	Запрос.УстановитьПараметр("ПериодНачало", НачалоГода(ДатаГрафика));
	Запрос.УстановитьПараметр("ПериодКонец", КонецГода(ДатаГрафика));
	Запрос.УстановитьПараметр("РесурсПредприятия", Объект.Ссылка);
	
	ВыборкаРезультатЗапроса = Запрос.Выполнить().Выбрать();
	
	Пока ВыборкаРезультатЗапроса.Следующий() Цикл
		
		СтрокаТаблицыГрафиков = ТаблицаГрафиков.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицыГрафиков, ВыборкаРезультатЗапроса);
		СтрокаТаблицыГрафиков.Цвет = ВыборкаРезультатЗапроса.Цвет.Получить();
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьТаблицуГрафиков

// Процедура получает текущий график, соответствующий выбранному периоду.
//
&НаКлиенте
Функция ПолучитьТекущийГрафик()
	
	Если Переключатель = "Год" Тогда
		ВыделеннаяОбласть = РасписаниеПоГрафику.ВыделенныеОбласти[0];
		НомерМесяца = ВыделеннаяОбласть.Верх - 1;
		НомерДня = ВыделеннаяОбласть.Лево - 1;
		Если НомерМесяца < 1 ИЛИ НомерМесяца > 12 ИЛИ НомерДня < 1 ИЛИ НомерДня > 31 ИЛИ НомерДня > КоличествоДнейВМесяцеНаКлиенте(НомерМесяца, Год(ДатаГрафика)) Тогда
			Возврат Неопределено;
		КонецЕсли;
		ТекДата = Дата(Год(ДатаГрафика), НомерМесяца, НомерДня, 0, 0, 0);
	Иначе
		ТекДата = НачалоДня(ДатаГрафика);
	КонецЕсли;
	
	Возврат ПолучитьТекущийГрафикНаДату(ТекДата);
	
КонецФункции // ПолучитьТекущийГрафик()

// Процедура получает текущий график на дату.
//
&НаКлиенте
Функция ПолучитьТекущийГрафикНаДату(Дата)
	
	Для каждого ТекГрафик Из ТаблицаГрафиков Цикл
		Если Дата >= НачалоДня(ТекГрафик.Период) Тогда
			ГрафикРаботы = ТекГрафик.ГрафикРаботы;
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ ЗначениеЗаполнено(ГрафикРаботы) Тогда
		ГрафикРаботы = НСтр("ru='<Не установлен>'");
		Элементы.График.Гиперссылка = Ложь;
	Иначе 
		Элементы.График.Гиперссылка = Истина;
	КонецЕсли;
	
	Возврат ГрафикРаботы;
	
КонецФункции // ПолучитьТекущийГрафикНаДату()

// Процедура отмечает выбранный период как нерабочий в представлении Год.
//
&НаКлиенте
Процедура ОтметитьВыбранноеКакНеРабочееГод()
	
	ТаблицаВыбранные.Очистить();
	ВыделенныеОбласти = РасписаниеПоГрафику.ВыделенныеОбласти;
	
	ЕстьПодходящиеДни = Ложь;
	ТекГрафик = Неопределено;
	
	Для каждого ТекОбласть Из ВыделенныеОбласти Цикл
		
		Если ТипЗнч(ТекОбласть) <> Тип("ОбластьЯчеекТабличногоДокумента") Тогда
			Продолжить;
		КонецЕсли;
		
		Для ТекСтрока = ТекОбласть.Верх По ТекОбласть.Низ Цикл
			Для ТекКолонка = ТекОбласть.Лево По ТекОбласть.Право Цикл
				Если ТекКолонка >= 2 И ТекКолонка <= 32 И ТекСтрока >= 2 И ТекСтрока <= 13 Тогда
					Попытка
						ТекДата = Дата(Год(ДатаГрафика), ТекСтрока - 1, ТекКолонка - 1, 0, 0, 0);
					Исключение
						Продолжить;
					КонецПопытки;
					ЕстьПодходящиеДни = Истина;
					ТекГрафик = ПолучитьТекущийГрафикНаДату(ТекДата);
					Если ТекГрафик = Неопределено Тогда
						Продолжить;
					КонецЕсли;
					НоваяСтрока = ТаблицаВыбранные.Добавить();
					НоваяСтрока.Верх = ТекСтрока - 1;
					НоваяСтрока.Лево = ТекКолонка - 1;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
	КонецЦикла;
	
	Если ЕстьПодходящиеДни
	   И ТекГрафик = Неопределено Тогда
		ПоказатьПредупреждение(Неопределено,НСтр("ru='Установите вначале график для выбранных дней!'"));
	КонецЕсли;
	
	ОтметитьВыбранноеКакНеРабочееГодНаСервере();
	СформироватьИтоги();
	
КонецПроцедуры // ОтметитьВыбранноеКакНеРабочееГод

// Процедура отмечает выбранный период как нерабочий в представлении День.
//
&НаКлиенте
Процедура ОтметитьВыбранноеКакНеРабочееДень()
	
	ТекГрафик = ПолучитьТекущийГрафикНаДату(ДатаГрафика);
	Если ТекГрафик = Неопределено Тогда
		ПоказатьПредупреждение(Неопределено,НСтр("ru='Установите вначале график для этого дня!'"));
		Возврат;
	КонецЕсли;
	
	УстановитьЦветФонаВыбраннымОбластям(ЦветСвободногоПериода);
	ЗаписатьОтклоненияВРегистр();
	
КонецПроцедуры // ОтметитьВыбранноеКакНеРабочееДень()

// Процедура отмечает выбранный период как нерабочий в представлении Год на сервере.
//
&НаСервере
Процедура ОтметитьВыбранноеКакНеРабочееГодНаСервере()
	
	Для каждого ТекОбласть Из ТаблицаВыбранные Цикл
		
		НаборЗаписей = РегистрыСведений.ОтклоненияОтГрафиковРаботыРесурсов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.РесурсПредприятия.Установить(Объект.Ссылка);
		НаборЗаписей.Отбор.Год.Установить(Год(ДатаГрафика));
		НаборЗаписей.Отбор.День.Установить(Дата(Год(ДатаГрафика), ТекОбласть.Верх, ТекОбласть.Лево, 0, 0, 0));
		НаборЗаписей.Записать(Истина);
		
		НаборЗаписей = РегистрыСведений.ОтклоненияОтГрафиковРаботыРесурсов.СоздатьНаборЗаписей();
		НоваяСтрока = НаборЗаписей.Добавить();
		НоваяСтрока.РесурсПредприятия = Объект.Ссылка;
		НоваяСтрока.Год = Год(ДатаГрафика);
		НоваяСтрока.День = Дата(Год(ДатаГрафика), ТекОбласть.Верх, ТекОбласть.Лево, 0, 0, 0);
		НоваяСтрока.ВремяНачала = Дата(Год(ДатаГрафика), ТекОбласть.Верх, ТекОбласть.Лево, 0, 0, 0);
		НоваяСтрока.ВремяОкончания = Дата(Год(ДатаГрафика), ТекОбласть.Верх, ТекОбласть.Лево, 23, 59, 59);
		НоваяСтрока.НеРабочийДень = Истина;
		НаборЗаписей.Записать(Ложь);
		
	КонецЦикла;
	
	ВывестиРасписаниеПоГрафику();
	
КонецПроцедуры // ОтметитьВыбранноеКакНеРабочееГодНаСервере()

// Процедура отмечает выбранный период как рабочий в представлении Год.
//
&НаКлиенте
Процедура ОтметитьВыбранноеКакРабочееГод()
	
	ТаблицаВыбранные.Очистить();
	ВыделенныеОбласти = РасписаниеПоГрафику.ВыделенныеОбласти;
	
	ЕстьПодходящиеДни = Ложь;
	ТекГрафик = Неопределено;
	
	Для каждого ТекОбласть Из ВыделенныеОбласти Цикл
		
		Если ТипЗнч(ТекОбласть) <> Тип("ОбластьЯчеекТабличногоДокумента") Тогда
			Продолжить;
		КонецЕсли;
		
		Для ТекСтрока = ТекОбласть.Верх По ТекОбласть.Низ Цикл
			Для ТекКолонка = ТекОбласть.Лево По ТекОбласть.Право Цикл
				Если ТекКолонка >= 2 И ТекКолонка <= 32 И ТекСтрока >= 2 И ТекСтрока <= 13 Тогда
					Попытка
						ТекДата = Дата(Год(ДатаГрафика), ТекСтрока - 1, ТекКолонка - 1, 0, 0, 0);
					Исключение
						Продолжить;
					КонецПопытки;
					ЕстьПодходящиеДни = Истина;
					ТекГрафик = ПолучитьТекущийГрафикНаДату(ТекДата);
					Если ТекГрафик = Неопределено Тогда
						Продолжить;
					КонецЕсли;
					НоваяСтрока = ТаблицаВыбранные.Добавить();
					НоваяСтрока.Верх = ТекСтрока - 1;
					НоваяСтрока.Лево = ТекКолонка - 1;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
	КонецЦикла;
	
	Если ЕстьПодходящиеДни
	   И ТекГрафик = Неопределено Тогда
		ПоказатьПредупреждение(Неопределено,НСтр("ru='Установите вначале график для выбранных дней!'"));
	КонецЕсли;
	
	ОтметитьВыбранноеКакРабочееГодНаСервере();
	СформироватьИтоги();
	
Конецпроцедуры // ОтметитьВыбранноеКакРабочееГод()

// Процедура отмечает выбранный период как рабочий в представлении День.
//
&НаКлиенте
Процедура ОтметитьВыбранноеКакРабочееДень()
	
	ТекГрафик = ПолучитьТекущийГрафикНаДату(ДатаГрафика);
	Если ТекГрафик = Неопределено Тогда
		ПоказатьПредупреждение(Неопределено,НСтр("ru='Установите вначале график для этого дня!'"));
		Возврат;
	КонецЕсли;
	
	УстановитьЦветФонаВыбраннымОбластям(ЦветЗанятогоПериода);
	ЗаписатьОтклоненияВРегистр();
	
Конецпроцедуры // ОтметитьВыбранноеКакРабочееДень()

// Функция проверяет возможность установки цвета для текущей строки и колонки.
//
&НаКлиенте
Функция ПроверитьВозможностьУстановкиЦвета(ТекКолонка, ТекСтрока)
	
	Если (ТекКолонка >= 2 И ТекКолонка <= 78 И ТекКолонка <> 14 И ТекКолонка <> 27 И ТекКолонка <> 40 И ТекКолонка <> 53 И ТекКолонка <> 66)
		И (ТекСтрока = 2 ИЛИ ТекСтрока = 4 ИЛИ ТекСтрока = 6 ИЛИ ТекСтрока = 8)  Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции // ПроверитьВозможностьУстановкиЦвета()

// Процедура устанавливает цвет фона выбранным областям.
//
&НаКлиенте
Процедура УстановитьЦветФонаВыбраннымОбластям(Цвет)
	
	ВыделенныеОбласти = РасписаниеПоГрафику.ВыделенныеОбласти;
	
	Для каждого ТекОбласть Из ВыделенныеОбласти Цикл
		
		Если ТипЗнч(ТекОбласть) <> Тип("ОбластьЯчеекТабличногоДокумента") Тогда
			Продолжить;
		КонецЕсли;
		
		Для ТекСтрока = ТекОбласть.Верх По ТекОбласть.Низ Цикл
			Для ТекКолонка = ТекОбласть.Лево По ТекОбласть.Право Цикл
				Если ПроверитьВозможностьУстановкиЦвета(ТекКолонка, ТекСтрока) Тогда
					Область = РасписаниеПоГрафику.Область("R" + ТекСтрока + "C" + ТекКолонка);
					Область.ЦветФона = Цвет;
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры // УстановитьЦветФонаВыбраннымОбластям()

// Процедура записывает отклонения в регистр.
//
&НаСервере
Процедура ЗаписатьОтклоненияВРегистр()
	
	НаборЗаписей = РегистрыСведений.ОтклоненияОтГрафиковРаботыРесурсов.СоздатьНаборЗаписей();
	
	НаборЗаписей.Отбор.РесурсПредприятия.Установить(Объект.Ссылка);
	НаборЗаписей.Отбор.Год.Установить(Год(ДатаГрафика));
	НаборЗаписей.Отбор.День.Установить(НачалоДня(ДатаГрафика));
	НаборЗаписей.Записать(Истина);
	
	НаборЗаписей = РегистрыСведений.ОтклоненияОтГрафиковРаботыРесурсов.СоздатьНаборЗаписей();
	
	ОткрытИнтервал = Ложь;
	ЕстьРабочееВремя = Ложь;
	
	КоличествоКолонок = 360 / КратностьДня;
	КоличествоСекундВПериоде = КратностьДня * 60;
	КоличествоПериодовВКолонке = 60 / КратностьДня;
	
	Для ТекСтрока = 1 По 4 Цикл
		Для ТекКолонка = 1 По 72 Цикл
			
			ТекПериодНачало = НачалоДня(ДатаГрафика) + (ТекСтрока - 1) * КоличествоКолонок * КоличествоСекундВПериоде + ТекКолонка * КоличествоСекундВПериоде - КоличествоСекундВПериоде;
			СтрокаТаблицы = ТекСтрока * 2;
			КоэфКолонкаТаблицы = ?(ТекКолонка / КоличествоПериодовВКолонке - Окр(ТекКолонка / КоличествоПериодовВКолонке) > 0, Окр(ТекКолонка / КоличествоПериодовВКолонке + 0.5), Окр(ТекКолонка / КоличествоПериодовВКолонке));
			
			КолонкаТаблицы = ТекКолонка + ТекКолонка * (КратностьДня / 5 - 1) - КратностьДня / 5 + 1 + КоэфКолонкаТаблицы;
			Область = РасписаниеПоГрафику.Область("R" + СтрокаТаблицы + "C" + КолонкаТаблицы);
			
			Если Область.ЦветФона = ЦветаСтиля.РабочееВремяЗанятоПолностью Тогда
				Если НЕ ОткрытИнтервал Тогда
					ОткрытИнтервал = Истина;
					НоваяЗапись = НаборЗаписей.Добавить();
					НоваяЗапись.РесурсПредприятия = Объект.Ссылка;
					НоваяЗапись.Год = Год(ДатаГрафика);
					НоваяЗапись.День = НачалоДня(ДатаГрафика);
					НоваяЗапись.ВремяНачала = ТекПериодНачало;
					НоваяЗапись.НеРабочийДень = Ложь;
					ЕстьРабочееВремя = Истина;
				КонецЕсли;
			Иначе
				Если ОткрытИнтервал Тогда
					ОткрытИнтервал = Ложь;
					НоваяЗапись.ВремяОкончания = ТекПериодНачало;
				КонецЕсли;
			КонецЕсли;
			
			Если ТекКолонка = КоличествоКолонок И ТекСтрока = 4 И ОткрытИнтервал Тогда
				ОткрытИнтервал = Ложь;
				НоваяЗапись.ВремяОкончания = КонецДня(ДатаГрафика);
			КонецЕсли;
			
		КонецЦикла;
	КонецЦикла;
	
	Если НЕ ЕстьРабочееВремя Тогда
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.РесурсПредприятия = Объект.Ссылка;
		НоваяЗапись.Год = Год(ДатаГрафика);
		НоваяЗапись.День = НачалоДня(ДатаГрафика);
		НоваяЗапись.ВремяНачала = НачалоДня(ДатаГрафика);
		НоваяЗапись.ВремяОкончания = КонецДня(ДатаГрафика);
		НоваяЗапись.НеРабочийДень = Истина;
	КонецЕсли;
	
	НаборЗаписей.Записать(Ложь);
	
КонецПроцедуры // ЗаписатьОтклоненияВРегистр()

// Процедура отмечает выбранный период как рабочий в представлении Год на сервере.
//
&НаСервере
Процедура ОтметитьВыбранноеКакРабочееГодНаСервере()
	
	Для каждого ТекОбласть Из ТаблицаВыбранные Цикл
		НаборЗаписей = РегистрыСведений.ОтклоненияОтГрафиковРаботыРесурсов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.РесурсПредприятия.Установить(Объект.Ссылка);
		НаборЗаписей.Отбор.Год.Установить(Год(ДатаГрафика));
		НаборЗаписей.Отбор.День.Установить(Дата(Год(ДатаГрафика), ТекОбласть.Верх, ТекОбласть.Лево, 0, 0, 0));
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.РесурсПредприятия = Объект.Ссылка;
		НоваяЗапись.Год = Год(ДатаГрафика);
		НоваяЗапись.День = Дата(Год(ДатаГрафика), ТекОбласть.Верх, ТекОбласть.Лево, 0, 0, 0);
		НоваяЗапись.ВремяНачала = Дата(Год(ДатаГрафика), ТекОбласть.Верх, ТекОбласть.Лево, 8, 0, 0);
		НоваяЗапись.ВремяОкончания = Дата(Год(ДатаГрафика), ТекОбласть.Верх, ТекОбласть.Лево, 16, 0, 0);
		НаборЗаписей.Записать(Истина);
	КонецЦикла;
	
	ВывестиРасписаниеПоГрафику();
	
КонецПроцедуры // ОтметитьВыбранноеКакРабочееГодНаСервере()

// Процедура отменяет все введенные отклонения за год.
//
&НаСервере
Процедура ОтменитьВсеИзмененияГрафикаГодНаСервере()
	
	НаборЗаписей = РегистрыСведений.ОтклоненияОтГрафиковРаботыРесурсов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.РесурсПредприятия.Установить(Объект.Ссылка);
	НаборЗаписей.Отбор.Год.Установить(Год(ДатаГрафика));
	НаборЗаписей.Записать(Истина);
	
	ВывестиРасписаниеПоГрафику();
	
КонецПроцедуры // ОтменитьВсеИзмененияГрафикаНаСервере()

// Процедура отменяет все введенные отклонения за день.
//
&НаСервере
Процедура ОтменитьВсеИзмененияГрафикаДеньНаСервере()
	
	НаборЗаписей = РегистрыСведений.ОтклоненияОтГрафиковРаботыРесурсов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.РесурсПредприятия.Установить(Объект.Ссылка);
	НаборЗаписей.Отбор.Год.Установить(Год(ДатаГрафика));
	НаборЗаписей.Отбор.День.Установить(НачалоДня(ДатаГрафика));
	НаборЗаписей.Записать(Истина);
	
	ВывестиРасписаниеПоГрафику();
	
КонецПроцедуры // ОтменитьВсеИзмененияГрафикаДеньНаСервере()

// Процедура устанавливает график на сервере.
//
&НаСервере
Процедура УстановитьГрафикНаСервере(Период)
	
	НаборЗаписей = РегистрыСведений.ГрафикиРаботыРесурсов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Период.Установить(Период);
	НаборЗаписей.Отбор.РесурсПредприятия.Установить(Объект.Ссылка);
	
	НаборЗаписей.Записать(Истина);
	
	НаборЗаписей = РегистрыСведений.ГрафикиРаботыРесурсов.СоздатьНаборЗаписей();
	
	НоваяСтрока = НаборЗаписей.Добавить();
	НоваяСтрока.Период = Период;
	НоваяСтрока.РесурсПредприятия = Объект.Ссылка;
	НоваяСтрока.ГрафикРаботы = График;
	
	НаборЗаписей.Записать(Ложь);
	
	ВывестиРасписаниеПоГрафику();
	
КонецПроцедуры // УстановитьГрафикНаСервере()

// Процедура - обработчик события Выбор табличного документа РасписаниеПоГрафику.
//
&НаКлиенте
Процедура РасписаниеПоГрафикуВыбор(Элемент, Область, СтандартнаяОбработка)
	
	Если Переключатель = "День"
	 ИЛИ Область.Лево = 1
	 ИЛИ Область.Низ = 1
	 ИЛИ Область.Низ > 13
	 ИЛИ Область.Лево - 1 > КоличествоДнейВМесяцеНаКлиенте(Область.Низ - 1, Год(ДатаГрафика)) Тогда
		Возврат;
	КонецЕсли;
	
	ДатаГрафика = Дата(Год(ДатаГрафика), Область.Низ - 1, Область.Лево - 1);
	
	Переключатель = "День";
	
	ЗаполнитьПредставлениеПериода();
	ВывестиРасписаниеПоГрафику();
	СформироватьИтоги();
	
КонецПроцедуры // РасписаниеПоГрафикуВыбор()

// Процедура - обработчик события НачалоВыбора поля ввода РасписаниеПоГрафикуПредставлениеПериода.
//
&НаКлиенте
Процедура РасписаниеПоГрафикуПредставлениеПериодаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СтруктураПараметров = Новый Структура("ДатаКалендаря", ДатаГрафика);
	ДатаКалендаряНачало = Неопределено;

	ОткрытьФорму("ОбщаяФорма.ФормаКалендаря", СтруктураПараметров,,,,, Новый ОписаниеОповещения("РасписаниеПоГрафикуПредставлениеПериодаНачалоВыбораЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура РасписаниеПоГрафикуПредставлениеПериодаНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если ЗначениеЗаполнено(Результат) Тогда
		
		ДатаКалендаряНачало = Результат;
		
		ДатаГрафика = КонецДня(ДатаКалендаряНачало);
		
		ЗаполнитьПредставлениеПериода();
		ВывестиРасписаниеПоГрафику();
		СформироватьИтоги();
		График = ПолучитьТекущийГрафик();
		
	КонецЕсли;
	
КонецПроцедуры // РасписаниеПоГрафикуПредставлениеПериодаНачалоВыбора()

// Процедура формирует итоги.
&НаКлиенте
Процедура СформироватьИтоги()
	
	ВсегоНерабочихДней = 0;
	ВсегоРабочихДней = 0;
	ВсегоРабочихЧасов = 0;
	
	РабочихЧасов = 0;
	
	Если Переключатель = "День" Тогда
		
		Для ТекСтрока = 1 По 4 Цикл
			Для ТекКолонка = 1 По 72 Цикл
				
				ТекПериодНачало = НачалоДня(ДатаГрафика) + (ТекСтрока - 1) * 72 * 300 + ТекКолонка * 300 - 300;
				СтрокаТаблицы = ТекСтрока * 2;
				КоэфКолонкаТаблицы = ?(ТекКолонка / 12 - Окр(ТекКолонка / 12) > 0, Окр(ТекКолонка / 12 + 0.5), Окр(ТекКолонка / 12));
				
				КолонкаТаблицы = ТекКолонка + КоэфКолонкаТаблицы;
				Область = РасписаниеПоГрафику.Область("R" + СтрокаТаблицы + "C" + КолонкаТаблицы);
				
				Если Область.ЦветФона = ЦветЗанятогоПериода Тогда
					РабочихЧасов = РабочихЧасов + 1/12;
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
		
		ВсегоРабочихЧасов = Окр(РабочихЧасов);
		
	Иначе
		
		Для НомерМесяца = 1 По 12 Цикл
			КоличествоДней = КоличествоДнейВМесяцеНаКлиенте(НомерМесяца, Год(ДатаГрафика));
			Для НомерДня = 1 По 31 Цикл
				Если НомерДня > КоличествоДней Тогда
					Продолжить;
				КонецЕсли;
				Область = РасписаниеПоГрафику.Область("R" + Строка(НомерМесяца + 1) + "C" + Строка(НомерДня + 1));
				Если Область.Текст = "" Тогда
					ВсегоНерабочихДней = ВсегоНерабочихДней + 1;
				Иначе
					ВсегоРабочихДней = ВсегоРабочихДней + 1;
					ВсегоРабочихЧасов = ВсегоРабочихЧасов + Число(?(Область.Текст = "В", 0, Область.Текст));
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
	КонецЕсли;
	
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
