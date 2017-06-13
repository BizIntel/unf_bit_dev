﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка доступности цен для редактирования.
	Элементы.Список.ТолькоПросмотр = НЕ УправлениеНебольшойФирмойУправлениеДоступомПовтИсп.ЕстьПравоДоступа(
		"Изменение",
		ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Метаданные.РегистрыСведений.ЦеныНоменклатуры)
	);
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаДиаграмма", "Пометка", Истина);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Номенклатура", Параметры.Отбор.Номенклатура, ВидСравненияКомпоновкиДанных.Равно, "Номенклатура", Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СписокИстория, "Номенклатура", Параметры.Отбор.Номенклатура, ВидСравненияКомпоновкиДанных.Равно, "Номенклатура", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьСписокЦенНоменклатуры" Тогда
		
		Элементы.Список.Обновить();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ИнициироватьЗаполнениеДиаграммы", 0.2, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийКомандФормы

&НаКлиенте
Процедура Диаграмма(Команда)
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаДиаграмма", "Пометка", НЕ Элементы.ФормаДиаграмма.Пометка);
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ДинамикаИзмененияЦены", "Видимость", Элементы.ФормаДиаграмма.Пометка);
	
КонецПроцедуры

&НаКлиенте
Процедура Хронология(Команда)
	
	СоответствиеСтраниц = Новый Соответствие;
	СоответствиеСтраниц.Вставить(Элементы.СтраницаСписок, Элементы.СтраницаСписокИстория);
	СоответствиеСтраниц.Вставить(Элементы.СтраницаСписокИстория, Элементы.СтраницаСписок);
	
	Элементы.Страницы.ТекущаяСтраница = СоответствиеСтраниц.Получить(Элементы.Страницы.ТекущаяСтраница);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьДиаграммуНаСервере(ДанныеТекущейСтроки)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 10
	|	ЦеныНоменклатуры.Период КАК Период
	|	,ЦеныНоменклатуры.Цена КАК Цена
	|ПОМЕСТИТЬ ЦеныНоменклатуры
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры КАК ЦеныНоменклатуры
	|ГДЕ
	|	ЦеныНоменклатуры.Номенклатура = &Номенклатура
	|	И ЦеныНоменклатуры.Характеристика = &Характеристика
	|	И ЦеныНоменклатуры.ВидЦен = &ВидЦен
	|	И ЦеныНоменклатуры.ЕдиницаИзмерения = &ЕдиницаИзмерения
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период УБЫВ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЦеныНоменклатуры.Период КАК Период
	|	,ЦеныНоменклатуры.Цена
	|ИЗ
	|	ЦеныНоменклатуры КАК ЦеныНоменклатуры
	|
	|УПОРЯДОЧИТЬ ПО
	|	Период";
	
	Запрос.УстановитьПараметр("Номенклатура",		ДанныеТекущейСтроки.Номенклатура);
	Запрос.УстановитьПараметр("ВидЦен", 			ДанныеТекущейСтроки.ВидЦен);
	
	Если ДанныеТекущейСтроки.Свойство("Характеристика") Тогда
		
		Запрос.УстановитьПараметр("Характеристика",	ДанныеТекущейСтроки.Характеристика);
		
	Иначе
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И ЦеныНоменклатуры.Характеристика = &Характеристика", "");
		
	КонецЕсли;
	
	Если ДанныеТекущейСтроки.Свойство("ЕдиницаИзмерения") Тогда
		
		Запрос.УстановитьПараметр("ЕдиницаИзмерения", ДанныеТекущейСтроки.ЕдиницаИзмерения);
		
	Иначе
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "И ЦеныНоменклатуры.ЕдиницаИзмерения = &ЕдиницаИзмерения", "");
		
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ДинамикаИзмененияЦены.Очистить();
	ДинамикаИзмененияЦены.Обновление = Ложь;
	ДинамикаИзмененияЦены.ВидПодписей = ВидПодписейКДиаграмме.Значение;
	
	Серия = ДинамикаИзмененияЦены.Серии.Добавить("История цены");
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Количество() = 1 Тогда
			
			ДатаБезВремени		= Формат(Выборка.Период, "ДЛФ=D");
			ЦенаСтрокой			= Строка("0");
			НоваяТочка 			= ДинамикаИзмененияЦены.Точки.Добавить(Строка(ДатаБезВремени));
			ДинамикаИзмененияЦены.УстановитьЗначение(НоваяТочка, Серия, 0, , ЦенаСтрокой);
			
		КонецЕсли;
		
		ДатаБезВремени		= Формат(Выборка.Период, "ДЛФ=D");
		ЦенаСтрокой			= Строка(Формат(Выборка.Цена, "ЧЦ=15; ЧДЦ=2; ЧРГ="));
		НоваяТочка 			= ДинамикаИзмененияЦены.Точки.Добавить(Строка(ДатаБезВремени));
		ДинамикаИзмененияЦены.УстановитьЗначение(НоваяТочка, Серия, Выборка.Цена, , ЦенаСтрокой);
		
	КонецЦикла;
	
	ДинамикаИзмененияЦены.Обновление = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ИнициироватьЗаполнениеДиаграммы()
	
	Если Элементы.ФормаДиаграмма.Пометка Тогда
		
		ДанныеСтроки = Элементы.Список.ТекущиеДанные;
		Если ДанныеСтроки <> Неопределено Тогда
			
			ДанныеТекущейСтроки = Новый Структура("Номенклатура, ВидЦен", ДанныеСтроки.Номенклатура, ДанныеСтроки.ВидЦен);
			Если ДанныеСтроки.Свойство("Характеристика") Тогда
				
				ДанныеТекущейСтроки.Вставить("Характеристика", ДанныеСтроки.Характеристика);
				
			КонецЕсли;
			
			Если ДанныеСтроки.Свойство("ЕдиницаИзмерения") Тогда
				
				ДанныеТекущейСтроки.Вставить("ЕдиницаИзмерения", ДанныеСтроки.ЕдиницаИзмерения);
				
			КонецЕсли;
			
			ОбновитьДиаграммуНаСервере(ДанныеТекущейСтроки);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти



