﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	НастройкиОтчета.ИспользоватьСравнение = Истина;
	НастройкиОтчета.ИспользоватьПериодичность = Истина;
	
	ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов);
	УстановитьТегиВариантов(НастройкиВариантов);
	ДобавитьОписанияСвязанныхПолей(НастройкиВариантов);
	
КонецПроцедуры

#КонецОбласти 

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
		
	НастройкиОтчета = КомпоновщикНастроек.Настройки;
	ПараметрыОтчета = ПодготовитьПараметрыОтчета(НастройкиОтчета);
	
	УправлениеНебольшойФирмойОтчеты.УстановитьМакетОформленияОтчета(НастройкиОтчета);
	УправлениеНебольшойФирмойОтчеты.ВывестиЗаголовокОтчета(ПараметрыОтчета, ДокументРезультат);
	
	// Найдем установленные параметры в настройках 
	Для каждого Элемент Из НастройкиОтчета.ПараметрыДанных.Элементы Цикл
		
		Если Элемент.Параметр = Новый ПараметрКомпоновкиДанных("СтПериод") Тогда
			
			Если Элемент.Использование И ЗначениеЗаполнено(Элемент.Значение) Тогда
				
				НачалоПериода = Элемент.Значение.ДатаНачала;
				КонецПериода  = Элемент.Значение.ДатаОкончания;
				
			Иначе
				
				НачалоПериода = '00010101';
				КонецПериода = КонецДня(ТекущаяДата());
				
			КонецЕсли;
			
		ИначеЕсли Элемент.Параметр = Новый ПараметрКомпоновкиДанных("Периодичность") Тогда
			
			Если Элемент.Использование И ЗначениеЗаполнено(Элемент.Значение) Тогда
				Периодичность = Элемент.Значение;
			Иначе
				Периодичность = "Месяц";
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// Получим таблицу с объемами
	СКД = ПолучитьМакет("СхемаСреднийОбъем");
	СКД.НаборыДанных.НаборДанныхСреднийОбъем.Запрос = СтрЗаменить(СКД.НаборыДанных.НаборДанныхСреднийОбъем.Запрос, "МЕСЯЦ", Периодичность);
	КомпоновщикНастроекДанных = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроекДанных.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СКД));
	КомпоновщикНастроекДанных.ЗагрузитьНастройки(СКД.НастройкиПоУмолчанию);
	
	КомпоновщикНастроекДанных.Настройки.Структура.Очистить();
	Группировка = ДобавитьГруппировку(КомпоновщикНастроекДанных, "");
	
	ДобавитьВыбранноеПолеСКД(Группировка, "Организация");
	ДобавитьВыбранноеПолеСКД(Группировка, "СтруктурнаяЕдиница");
	ДобавитьВыбранноеПолеСКД(Группировка, "СчетУчета");
	ДобавитьВыбранноеПолеСКД(Группировка, "Номенклатура");
	ДобавитьВыбранноеПолеСКД(Группировка, "Характеристика");
	ДобавитьВыбранноеПолеСКД(Группировка, "Партия");
	ДобавитьВыбранноеПолеСКД(Группировка, "Период");
	ДобавитьВыбранноеПолеСКД(Группировка, "КоличествоНачальныйОстаток");
	ДобавитьВыбранноеПолеСКД(Группировка, "КоличествоКонечныйОстаток");
	
	СкопироватьЭлементыОтбора(СКД, КомпоновщикНастроекДанных.Настройки.Отбор, НастройкиОтчета.Отбор);
	ЗаполнитьПараметры(КомпоновщикНастроекДанных.Настройки.ПараметрыДанных, НачалоПериода, КонецПериода);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СКД, КомпоновщикНастроекДанных.ПолучитьНастройки(), , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"), , );
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , , Истина);	
	Таблица = Новый ТаблицаЗначений;	
	
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(Таблица);	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);	
	
	// Рассчитаем средний объем	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ЗапасыОстаткиИОбороты.Организация КАК Организация,
	|	ЗапасыОстаткиИОбороты.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ЗапасыОстаткиИОбороты.СчетУчета КАК СчетУчета,
	|	ЗапасыОстаткиИОбороты.Номенклатура КАК Номенклатура,
	|	ЗапасыОстаткиИОбороты.Характеристика КАК Характеристика,
	|	ЗапасыОстаткиИОбороты.Партия КАК Партия,
	|	НАЧАЛОПЕРИОДА(ЗапасыОстаткиИОбороты.Период, &ПериодичностьТекст) КАК Период,
	|	ЗапасыОстаткиИОбороты.КоличествоНачальныйОстаток КАК КоличествоНачальныйОстаток,
	|	ЗапасыОстаткиИОбороты.КоличествоКонечныйОстаток КАК КоличествоКонечныйОстаток
	|ПОМЕСТИТЬ ТаблицаСреднийОбъем
	|ИЗ
	|	&ТаблицаСреднийОбъем КАК ЗапасыОстаткиИОбороты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗапасыОстаткиИОбороты.Организация КАК Организация,
	|	ЗапасыОстаткиИОбороты.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	ЗапасыОстаткиИОбороты.СчетУчета КАК СчетУчета,
	|	ЗапасыОстаткиИОбороты.Номенклатура КАК Номенклатура,
	|	ЗапасыОстаткиИОбороты.Характеристика КАК Характеристика,
	|	ЗапасыОстаткиИОбороты.Партия КАК Партия,
	|	ЗапасыОстаткиИОбороты.Период КАК Период,
	|	ЗапасыОстаткиИОбороты.КоличествоНачальныйОстаток КАК КоличествоНачальныйОстаток,
	|	ЗапасыОстаткиИОбороты.КоличествоКонечныйОстаток КАК КоличествоКонечныйОстаток
	|ИЗ
	|	ТаблицаСреднийОбъем КАК ЗапасыОстаткиИОбороты
	|
	|УПОРЯДОЧИТЬ ПО
	|	Организация,
	|	СтруктурнаяЕдиница,
	|	СчетУчета,
	|	Номенклатура,
	|	Характеристика,
	|	Партия,
	|	Период
	|ИТОГИ
	|	СУММА(КоличествоНачальныйОстаток),
	|	СУММА(КоличествоКонечныйОстаток)
	|ПО
	|	Организация,
	|	СтруктурнаяЕдиница,
	|	СчетУчета,
	|	Номенклатура,
	|	Характеристика,
	|	Партия,
	|	Период ПЕРИОДАМИ(&ПериодичностьТекст, &НачалоПериода, &КонецПериода)");
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ПериодичностьТекст", Периодичность);
	Запрос.УстановитьПараметр("НачалоПериода", НачалоПериода);
	Запрос.УстановитьПараметр("КонецПериода", КонецПериода);
	Запрос.УстановитьПараметр("ТаблицаСреднийОбъем", СформироватьТаблицуПараметр(Таблица));
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	РезультатЗапроса = МассивРезультатов[1];
	
	ТаблицаРезультат = РезультатЗапроса.Выгрузить();
	ТаблицаИсточник = ТаблицаРезультат.СкопироватьКолонки();
	Массив = Новый Массив;
	Массив.Добавить(Тип("Число"));
	ОписаниеТипов = Новый ОписаниеТипов(Массив, ,);
	Массив.Очистить();
	ТаблицаИсточник.Колонки.Добавить("СреднийОбъем", ОписаниеТипов);
	ТаблицаИсточник.Колонки.Добавить("КоличествоДнейПериода", ОписаниеТипов);
	ТаблицаИсточник.Колонки.Удалить("КоличествоНачальныйОстаток");
	ТаблицаИсточник.Колонки.Удалить("КоличествоКонечныйОстаток");
	
	КоличествоДнейПериода = (КонецПериода + 1 - НачалоПериода)/(60*60*24);
	
	ВыборкаОрганизация = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Организация");
	Пока ВыборкаОрганизация.Следующий() Цикл
		ВыборкаСтруктурнаяЕдиница = ВыборкаОрганизация.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "СтруктурнаяЕдиница");
		Пока ВыборкаСтруктурнаяЕдиница.Следующий() Цикл
			ВыборкаСчетУчета = ВыборкаСтруктурнаяЕдиница.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "СчетУчета");
			Пока ВыборкаСчетУчета.Следующий() Цикл
				ВыборкаНоменклатура = ВыборкаСчетУчета.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Номенклатура");
				Пока ВыборкаНоменклатура.Следующий() Цикл
					ВыборкаХарактеристика = ВыборкаНоменклатура.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Характеристика");
					Пока ВыборкаХарактеристика.Следующий() Цикл
						ВыборкаПартия = ВыборкаХарактеристика.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Партия");
						Пока ВыборкаПартия.Следующий() Цикл
							
							Счетчик = 0;
							Сумма = 0;
							КоличествоНачальныйОстаток = 0;
							КоличествоКонечныйОстаток = 0;
							
							НоваяСтрока = ТаблицаИсточник.Добавить();
							ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаПартия);
							
							ВыборкаПериод = ВыборкаПартия.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "Период", "ВСЕ");
							Пока ВыборкаПериод.Следующий() Цикл
								
								Если ВыборкаПериод.КоличествоНачальныйОстаток <> NULL Тогда
									КоличествоНачальныйОстаток = ВыборкаПериод.КоличествоНачальныйОстаток;
									КоличествоКонечныйОстаток = ВыборкаПериод.КоличествоКонечныйОстаток;
								КонецЕсли; 
								
								Счетчик = Счетчик + 1;
								Сумма = Сумма + ?(Счетчик = 1, КоличествоНачальныйОстаток, 0) + КоличествоКонечныйОстаток;
									
							КонецЦикла;
							
							Если Счетчик = 0 Тогда
								НоваяСтрока.СреднийОбъем = 0;
							Иначе
							    НоваяСтрока.СреднийОбъем = Сумма / (Счетчик + 1);
							КонецЕсли;
							
							НоваяСтрока.КоличествоДнейПериода = КоличествоДнейПериода;
							
						КонецЦикла;
					КонецЦикла;	
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;	
	КонецЦикла; 
	
	СтруктураПараметры = Новый Структура("ТаблицаСреднийОбъем", ТаблицаИсточник);
	
	МассивЗаголовковРесурсов = Новый Массив; 
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровки);
	
	//Создадим и инициализируем процессор компоновки
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, СтруктураПараметры, ДанныеРасшифровки, Истина);

	//Создадим и инициализируем процессор вывода результата
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	
	//Обозначим начало вывода
	ПроцессорВывода.НачатьВывод();
	ТаблицаЗафиксирована = Ложь;

	ДокументРезультат.ФиксацияСверху = 0;
	//Основной цикл вывода отчета
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

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Копирует элементы из одной коллекции в другую
Процедура СкопироватьЭлементыОтбора(СКД, ПриемникЗначения, ИсточникЗначения) 
	
	ПриемникЭлементов = ПриемникЗначения.Элементы;
	ИсточникЭлементов = ИсточникЗначения.Элементы;
	ПриемникЭлементов.Очистить();
	
	Для каждого ЭлементИсточник Из ИсточникЭлементов Цикл
		
		ВыбранныеПоля = СКД.НастройкиПоУмолчанию.Выбор.Элементы;
		Для Каждого ВыбранноеПоле Из ВыбранныеПоля Цикл
			Если ЭлементИсточник.ЛевоеЗначение = ВыбранноеПоле.Поле Тогда
				ЭлементПриемник = ПриемникЭлементов.Добавить(ТипЗнч(ЭлементИсточник));
				ЗаполнитьЗначенияСвойств(ЭлементПриемник, ЭлементИсточник);
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПараметры(ПриемникЗначения, НачалоПериода, КонецПериода)
	
	ЭлементПриемник = ПриемникЗначения.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("НачалоПериода"));
	Если ЭлементПриемник <> Неопределено Тогда
		ЭлементПриемник.Значение = НачалоПериода;
	КонецЕсли;	
	
	ЭлементПриемник = ПриемникЗначения.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("КонецПериода"));
	Если ЭлементПриемник <> Неопределено Тогда
		ЭлементПриемник.Значение = КонецПериода;
	КонецЕсли;	
	
КонецПроцедуры

// Добавляет группировку в компоновщик настроек в самый нижний уровень структуры, если поле не указано - детальные поля
Функция ДобавитьГруппировку(КомпоновщикНастроек, Знач Поле = Неопределено, Строки = Истина)
	
	ЭлементСтруктуры = ПолучитьПоследнийЭлементСтруктуры(КомпоновщикНастроек, Строки);
	Поле = Новый ПолеКомпоновкиДанных(Поле);
	НоваяГруппировка = ЭлементСтруктуры.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	
	НоваяГруппировка.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	НоваяГруппировка.Порядок.Элементы.Добавить(Тип("АвтоЭлементПорядкаКомпоновкиДанных"));
	ПолеГруппировки = НоваяГруппировка.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
	ПолеГруппировки.Поле = Поле;
	
	Возврат НоваяГруппировка;
	
КонецФункции

// Возвращает последний элемент структуры - группировку
Функция ПолучитьПоследнийЭлементСтруктуры(ЭлементСтруктурыНастроек, Строки = Истина) Экспорт
	
	Если ТипЗнч(ЭлементСтруктурыНастроек) = Тип("КомпоновщикНастроекКомпоновкиДанных") тогда
		Настройки = ЭлементСтруктурыНастроек.Настройки;
	ИначеЕсли ТипЗнч(ЭлементСтруктурыНастроек) = Тип("НастройкиКомпоновкиДанных") тогда
		Настройки = ЭлементСтруктурыНастроек;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
	Структура = Настройки.Структура;
	Если Структура.Количество() = 0 Тогда
		Возврат Настройки;
	КонецЕсли;
	
	Если Строки Тогда
		ИмяСтруктурыТаблицы = "Строки";
		ИмяСтруктурыДиаграммы = "Серии";
	Иначе
		ИмяСтруктурыТаблицы = "Колонки";
		ИмяСтруктурыДиаграммы = "Точки";
	КонецЕсли;
	
	Пока Истина Цикл
		ЭлементСтруктуры = Структура[0];
		Если ТипЗнч(ЭлементСтруктуры) = Тип("ТаблицаКомпоновкиДанных") И ЭлементСтруктуры[ИмяСтруктурыТаблицы].Количество() > 0 Тогда
			Если ЭлементСтруктуры[ИмяСтруктурыТаблицы][0].Структура.Количество() = 0 Тогда
				Структура = ЭлементСтруктуры[ИмяСтруктурыТаблицы];
				Прервать;
			КонецЕсли;
			Структура = ЭлементСтруктуры[ИмяСтруктурыТаблицы][0].Структура;
		ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("ДиаграммаКомпоновкиДанных") И ЭлементСтруктуры[ИмяСтруктурыДиаграммы].Количество() > 0 Тогда
			Если ЭлементСтруктуры[ИмяСтруктурыДиаграммы][0].Структура.Количество() = 0 Тогда
				Структура = ЭлементСтруктуры[ИмяСтруктурыДиаграммы];
				Прервать;
			КонецЕсли;
			Структура = ЭлементСтруктуры[ИмяСтруктурыДиаграммы][0].Структура;
		ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("ГруппировкаКомпоновкиДанных")
			  ИЛИ ТипЗнч(ЭлементСтруктуры) = Тип("ГруппировкаТаблицыКомпоновкиДанных")
			  ИЛИ ТипЗнч(ЭлементСтруктуры) = Тип("ГруппировкаДиаграммыКомпоновкиДанных") Тогда
			Если ЭлементСтруктуры.Структура.Количество() = 0 Тогда
				Прервать;
			КонецЕсли;
			Структура = ЭлементСтруктуры.Структура;
		ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("ТаблицаКомпоновкиДанных") Тогда
			Возврат ЭлементСтруктуры[ИмяСтруктурыТаблицы];
		ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("ДиаграммаКомпоновкиДанных")	Тогда
			Возврат ЭлементСтруктуры[ИмяСтруктурыДиаграммы];
		Иначе
			Возврат ЭлементСтруктуры;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Структура[0];
	
КонецФункции

// Добавляет группировку в компоновщик настроек в самый нижний уровень структуры, если поле не указано - детальные поля
//
Процедура ДобавитьВыбранноеПолеСКД(ГруппировкаКомпоновкиДанных, Поле)
	
	ВыбранноеПоле               = ГруппировкаКомпоновкиДанных.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
	ВыбранноеПоле.Поле          = Новый ПолеКомпоновкиДанных(Поле);
	ВыбранноеПоле.Использование = Истина;
	
КонецПроцедуры // ДобавитьВыбранноеПолеСКД()

// Копирует таблицу в таблицу с определенными типами колонками
// 
Функция СформироватьТаблицуПараметр(Таблица)
	
	ТаблицаПараметр = Новый ТаблицаЗначений;
	Массив = Новый Массив;
	
	Массив.Добавить(Тип("Число"));
	ОписаниеТипов = Новый ОписаниеТипов(Массив, ,);
	Массив.Очистить();	
	ТаблицаПараметр.Колонки.Добавить("КоличествоНачальныйОстаток", ОписаниеТипов);
	ТаблицаПараметр.Колонки.Добавить("КоличествоКонечныйОстаток", ОписаниеТипов);
	
	Массив.Добавить(Тип("СправочникСсылка.Номенклатура"));
	ОписаниеТипов = Новый ОписаниеТипов(Массив, ,);
	Массив.Очистить();
	ТаблицаПараметр.Колонки.Добавить("Номенклатура", ОписаниеТипов);
	
	Массив.Добавить(Тип("СправочникСсылка.Организации"));
	ОписаниеТипов = Новый ОписаниеТипов(Массив, ,);
	Массив.Очистить();
	ТаблицаПараметр.Колонки.Добавить("Организация", ОписаниеТипов);
	
	Массив.Добавить(Тип("СправочникСсылка.ПартииНоменклатуры"));
	ОписаниеТипов = Новый ОписаниеТипов(Массив, ,);
	Массив.Очистить();
	ТаблицаПараметр.Колонки.Добавить("Партия", ОписаниеТипов);
	
	Массив.Добавить(Тип("Дата"));
	ОписаниеТипов = Новый ОписаниеТипов(Массив, ,);
	Массив.Очистить();	
	ТаблицаПараметр.Колонки.Добавить("Период", ОписаниеТипов);
	
	Массив.Добавить(Тип("СправочникСсылка.СтруктурныеЕдиницы"));
	ОписаниеТипов = Новый ОписаниеТипов(Массив, ,);
	Массив.Очистить();
	ТаблицаПараметр.Колонки.Добавить("СтруктурнаяЕдиница", ОписаниеТипов);
	
	Массив.Добавить(Тип("ПланСчетовСсылка.Управленческий"));
	ОписаниеТипов = Новый ОписаниеТипов(Массив, ,);
	Массив.Очистить();
	ТаблицаПараметр.Колонки.Добавить("СчетУчета", ОписаниеТипов);
	
	Массив.Добавить(Тип("СправочникСсылка.ХарактеристикиНоменклатуры"));
	ОписаниеТипов = Новый ОписаниеТипов(Массив, ,);
	Массив.Очистить();
	ТаблицаПараметр.Колонки.Добавить("Характеристика", ОписаниеТипов);
	
	Для каждого СтрокаТаблицы Из Таблица Цикл
		НоваяСтрока = ТаблицаПараметр.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаТаблицы);
	КонецЦикла;
	
	Возврат ТаблицаПараметр
	
КонецФункции

Функция ПодготовитьПараметрыОтчета(НастройкиОтчета)
	
	НачалоПериода = Дата(1,1,1);
	КонецПериода  = Дата(1,1,1);
	Периодичность = Перечисления.Периодичность.Месяц;
	ВыводитьЗаголовок = Ложь;
	Заголовок = "Оборачиваемость запасов";
	
	ПараметрПериод = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СтПериод"));
	Если ПараметрПериод <> Неопределено И ПараметрПериод.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.БыстрыйДоступ Тогда
		Если ПараметрПериод.Использование
			И ЗначениеЗаполнено(ПараметрПериод.Значение) Тогда
			
			НачалоПериода = ПараметрПериод.Значение.ДатаНачала;
			КонецПериода  = ПараметрПериод.Значение.ДатаОкончания;
		КонецЕсли;
	КонецЕсли;
	
	ПараметрПериодичность = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Периодичность"));
	Если ПараметрПериодичность <> Неопределено
		И ПараметрПериодичность.Использование
		И ЗначениеЗаполнено(ПараметрПериодичность.Значение) Тогда
		
		Периодичность = ПараметрПериодичность.Значение;
	КонецЕсли;
	
	ПараметрВыводитьЗаголовок = НастройкиОтчета.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВыводитьЗаголовок"));
	Если ПараметрВыводитьЗаголовок <> Неопределено
		И ПараметрВыводитьЗаголовок.Использование Тогда
		
		ВыводитьЗаголовок = ПараметрВыводитьЗаголовок.Значение;
	КонецЕсли;
	
	ПараметрВывода = НастройкиОтчета.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Заголовок"));
	Если ПараметрВывода <> Неопределено
		И ПараметрВывода.Использование Тогда
		Заголовок = ПараметрВывода.Значение;
	КонецЕсли;
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("НачалоПериода"            , НачалоПериода);
	ПараметрыОтчета.Вставить("КонецПериода"             , КонецПериода);
	ПараметрыОтчета.Вставить("Периодичность"            , Периодичность);
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок"        , ВыводитьЗаголовок);
	ПараметрыОтчета.Вставить("Заголовок"                , Заголовок);
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"      , "ОборачиваемостьЗапасов");
	ПараметрыОтчета.Вставить("НастройкиОтчета", НастройкиОтчета);
	
	
	Возврат ПараметрыОтчета;
	
КонецФункции

Процедура ЗаполнитьПредопределенныеВариантыОформления(НастройкиВариантов)
	
	МассивПолейКоличеств = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок("Расход,Оборачиваемость,СреднийОбъем,Остаток"); 
	
	Для каждого ОписаниеВараинта Из НастройкиВариантов Цикл
		
		ВариантыОформления = ОписаниеВараинта.Значение.ВариантыОформления;
		ОтчетыУНФ.ДобавитьВариантыОформленияКоличества(ВариантыОформления, МассивПолейКоличеств);
			
	КонецЦикла; 
	
КонецПроцедуры

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	НастройкиВариантов["Основной"].Теги = НСтр("ru = 'Запасы,Закупки,Номенклатура'");
	
КонецПроцедуры

Процедура ДобавитьОписанияСвязанныхПолей(НастройкиВариантов)
	
	ОтчетыУНФ.ДобавитьОписаниеПривязки(НастройкиВариантов["Основной"].СвязанныеПоля, "Номенклатура", "Справочник.Номенклатура");
	
КонецПроцедуры
 
#КонецОбласти

ЭтоОтчетУНФ = Истина;

#КонецЕсли
