﻿
Процедура ЗаполнитьТЧСерийныеНомераПоКлючуСвязи(ДокументОбъект, ДанныеЗаполнения, ИмяТЧЗапасы="Запасы", 
	ИмяТЧСерийныеНомераИсточник="СерийныеНомера", ИмяТЧСерийныеНомераПриемник="СерийныеНомера") Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьСерийныеНомера") Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектМетаданныхИмя = ДанныеЗаполнения.Метаданные().Имя;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументСерийныеНомера.СерийныйНомер,
	|	ДокументСерийныеНомера.КлючСвязи
	|ИЗ
	|	Документ."+ОбъектМетаданныхИмя+"."+ИмяТЧСерийныеНомераИсточник+" КАК ДокументСерийныеНомера
	|ГДЕ
	|	ДокументСерийныеНомера.Ссылка = &ДокСсылка
	|	И ДокументСерийныеНомера.КлючСвязи В(&КлючиСвязи)";
	
	Запрос.УстановитьПараметр("ДокСсылка", ДанныеЗаполнения.Ссылка);
	Запрос.УстановитьПараметр("КлючиСвязи", ДанныеЗаполнения[ИмяТЧЗапасы].ВыгрузитьКолонку("КлючСвязи"));
	
	ДокументОбъект[ИмяТЧСерийныеНомераПриемник].Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

Процедура ЗаполнитьТЧСерийныеНомераПоКлючуСвязиУстановитьНовыйКлючСвязи(ТЗСоответствиеКлючейСвязи, ДокументОбъект, ДанныеЗаполнения, ИмяТЧЗапасы="Запасы", 
	ИмяТЧСерийныеНомераИсточник="СерийныеНомера", ИмяТЧСерийныеНомераПриемник="СерийныеНомера", ЭтоСписание) Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьСерийныеНомера") Тогда
		Возврат;
	КонецЕсли;
	
	ОбъектМетаданныхИмя = ДанныеЗаполнения.Метаданные().Имя;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"Выбрать
	|	ТЗСоответствиеКлючейСвязи.КлючСвязиНовый,
	|	ТЗСоответствиеКлючейСвязи.КлючСвязи
	|Поместить ВременнаяТаблица_КлючиСвязи
	|	Из &ТЗСоответствиеКлючейСвязи КАК ТЗСоответствиеКлючейСвязи
	|ГДЕ ЭтоСписание = &ЭтоСписание
	|;
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ДокументСерийныеНомера.СерийныйНомер,
	|	ВременнаяТаблица_КлючиСвязи.КлючСвязиНовый КАК КлючСвязи
	|ИЗ
	|	Документ."+ОбъектМетаданныхИмя+"."+ИмяТЧСерийныеНомераИсточник+" КАК ДокументСерийныеНомера
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВременнаяТаблица_КлючиСвязи КАК ВременнаяТаблица_КлючиСвязи
	|		ПО ДокументСерийныеНомера.КлючСвязи = ВременнаяТаблица_КлючиСвязи.КлючСвязи
	|ГДЕ
	|	ДокументСерийныеНомера.Ссылка = &ДокСсылка
	|	И ДокументСерийныеНомера.КлючСвязи В(&КлючиСвязи)";
	
	Запрос.УстановитьПараметр("ДокСсылка", ДанныеЗаполнения.Ссылка);
	Запрос.УстановитьПараметр("КлючиСвязи", ДанныеЗаполнения[ИмяТЧЗапасы].ВыгрузитьКолонку("КлючСвязи"));
	Запрос.УстановитьПараметр("ТЗСоответствиеКлючейСвязи", ТЗСоответствиеКлючейСвязи);
	Запрос.УстановитьПараметр("ЭтоСписание", ЭтоСписание);
	
	РезультатТЗ = Запрос.Выполнить().Выгрузить();
	Для Каждого ТекущаяСтрока Из РезультатТЗ Цикл
		НоваяСтрока = ДокументОбъект[ИмяТЧСерийныеНомераПриемник].Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекущаяСтрока);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьТЧСерийныеНомераВШапке(ДокументОбъект, ДанныеЗаполнения, СтрокаТЧ, ИмяТЧСерийныеНомера="СерийныеНомера") Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьСерийныеНомера") Тогда
		Возврат;
	КонецЕсли;
	
	ДокументОбъект.СерийныеНомераПредставление = СтрокаТЧ.СерийныеНомера;
	СерийныеНомераСтроки_0 = ДанныеЗаполнения[ИмяТЧСерийныеНомера].НайтиСтроки(Новый Структура("КлючСвязи", СтрокаТЧ.КлючСвязи));
	ДокументОбъект[ИмяТЧСерийныеНомера].Загрузить(ДанныеЗаполнения[ИмяТЧСерийныеНомера].Выгрузить(СерийныеНомераСтроки_0));
		
КонецПроцедуры

Функция СтрокаСерийныеНомераИзВыборки(ВыборкаСтрокСерийныеНомера, КлючСвязи) Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьСерийныеНомера") Тогда
		Возврат "";
	КонецЕсли;
	
	СтруктураПоиска = Новый Структура("КлючСвязи", КлючСвязи);
	СтрокаСерийныхНомеров = "";
	Пока ВыборкаСтрокСерийныеНомера.НайтиСледующий(СтруктураПоиска) Цикл
		СтрокаСерийныхНомеров = СтрокаСерийныхНомеров + ВыборкаСтрокСерийныеНомера.СерийныйНомер + ", ";
	КонецЦикла;
	
	Если СтрДлина(СтрокаСерийныхНомеров) <> 0 Тогда
		СтрокаСерийныхНомеров = Лев(СтрокаСерийныхНомеров, СтрДлина(СтрокаСерийныхНомеров) - 2);
	КонецЕсли;
	
	ВыборкаСтрокСерийныеНомера.Сбросить();
	
	Возврат СтрокаСерийныхНомеров;
	
КонецФункции

Функция СтрокаСерийныеНомера(ТЧСерийныеНомера, КлючСвязи) Экспорт
	
	СтруктураПоиска = Новый Структура("КлючСвязи", КлючСвязи);
	СтрокаСерийныхНомеров = "";
	МассивСтрок = ТЧСерийныеНомера.НайтиСтроки(СтруктураПоиска);
	Для каждого стр из МассивСтрок Цикл
		СтрокаСерийныхНомеров = СтрокаСерийныхНомеров + стр.СерийныйНомер + ", ";
	КонецЦикла;
	
	Если СтрДлина(СтрокаСерийныхНомеров) <> 0 Тогда
		СтрокаСерийныхНомеров = Лев(СтрокаСерийныхНомеров, СтрДлина(СтрокаСерийныхНомеров) - 2);
	КонецЕсли;
	
	Возврат СтрокаСерийныхНомеров;
	
КонецФункции

Процедура ЗаполнитьСерийныеНомераВНаличии(ДокОбъект, ИмяТЧЗапасы="Запасы", ИмяТЧСерийныеНомера="СерийныеНомера") Экспорт
	
	РаботаСФормойДокумента.ЗаполнитьКлючиСвязи(ДокОбъект, ИмяТЧЗапасы);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаЗапасы.НомерСтроки,
	|	ТаблицаЗапасы.Номенклатура,
	|	ТаблицаЗапасы.Характеристика,
	|	ТаблицаЗапасы.Партия,
	|	ТаблицаЗапасы.Количество,
	|	ТаблицаЗапасы.КлючСвязи
	|ПОМЕСТИТЬ ВТЗапасы
	|ИЗ
	|	&ТаблицаЗапасы КАК ТаблицаЗапасы
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВложенныйЗапрос.СерийныйНомер КАК СерийныйНомер,
	|	ВложенныйЗапрос.НомерСтроки КАК НомерСтроки,
	|	ВложенныйЗапрос.КлючСвязи,
	|	ВложенныйЗапрос.Номенклатура,
	|	ВложенныйЗапрос.Количество КАК Количество
	|ИЗ
	|	(ВЫБРАТЬ
	|		СерийныеНомераОстатки.СерийныйНомер КАК СерийныйНомер,
	|		РасходнаяНакладнаяЗапасы.НомерСтроки КАК НомерСтроки,
	|		РасходнаяНакладнаяЗапасы.КлючСвязи КАК КлючСвязи,
	|		РасходнаяНакладнаяЗапасы.Номенклатура КАК Номенклатура,
	|		РасходнаяНакладнаяЗапасы.Количество КАК Количество
	|	ИЗ
	|		ВТЗапасы КАК РасходнаяНакладнаяЗапасы
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.СерийныеНомера.Остатки(
	|					,
	|					(&ВсеСклады
	|						ИЛИ СтруктурнаяЕдиница = &СтруктурнаяЕдиница)
	|						И (&ВсеЯчейки
	|							ИЛИ Ячейка = &Ячейка)) КАК СерийныеНомераОстатки
	|			ПО РасходнаяНакладнаяЗапасы.Номенклатура = СерийныеНомераОстатки.Номенклатура
	|				И РасходнаяНакладнаяЗапасы.Характеристика = СерийныеНомераОстатки.Характеристика
	|				И РасходнаяНакладнаяЗапасы.Партия = СерийныеНомераОстатки.Партия,
	|		Константа.КонтрольОстатковСерийныхНомеров КАК КонтрольОстатковСерийныхНомеров
	|	ГДЕ
	|		КонтрольОстатковСерийныхНомеров.Значение = Истина
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		спрСерийныеНомера.Ссылка,
	|		РасходнаяНакладнаяЗапасы.НомерСтроки,
	|		РасходнаяНакладнаяЗапасы.КлючСвязи,
	|		РасходнаяНакладнаяЗапасы.Номенклатура,
	|		РасходнаяНакладнаяЗапасы.Количество
	|	ИЗ
	|		Константа.КонтрольОстатковСерийныхНомеров КАК КонтрольОстатковСерийныхНомеров,
	|		ВТЗапасы КАК РасходнаяНакладнаяЗапасы
	|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СерийныеНомера КАК спрСерийныеНомера
	|			ПО РасходнаяНакладнаяЗапасы.Номенклатура = спрСерийныеНомера.Владелец
	|	ГДЕ
	|		НЕ спрСерийныеНомера.Продан
	|		И КонтрольОстатковСерийныхНомеров.Значение = Ложь) КАК ВложенныйЗапрос
	|
	|УПОРЯДОЧИТЬ ПО
	|	СерийныйНомер
	|ИТОГИ
	|	МИНИМУМ(Количество)
	|ПО
	|	НомерСтроки
	|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("ТаблицаЗапасы",ДокОбъект[ИмяТЧЗапасы].Выгрузить());
	
	Если НЕ ЗначениеЗаполнено(ДокОбъект.СтруктурнаяЕдиница) Тогда
		Запрос.УстановитьПараметр("ВсеСклады", Истина);
		Запрос.УстановитьПараметр("СтруктурнаяЕдиница",ДокОбъект.СтруктурнаяЕдиница);
	Иначе
		Запрос.УстановитьПараметр("ВсеСклады", Ложь);
		Запрос.УстановитьПараметр("СтруктурнаяЕдиница",ДокОбъект.СтруктурнаяЕдиница);
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ДокОбъект.Ячейка) Тогда
		Запрос.УстановитьПараметр("ВсеЯчейки", Истина);
		Запрос.УстановитьПараметр("Ячейка",ДокОбъект.Ячейка);
	Иначе
		Запрос.УстановитьПараметр("ВсеЯчейки", Ложь);
		Запрос.УстановитьПараметр("Ячейка",ДокОбъект.Ячейка);
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	ВыборкаНомерСтроки = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ДокОбъект[ИмяТЧСерийныеНомера].Очистить();
	Пока ВыборкаНомерСтроки.Следующий() Цикл
		
		КоличествоЗаполнить = ВыборкаНомерСтроки.Количество;
		КоличествоСН = 0;
		
		ВыборкаСерийныеНомера = ВыборкаНомерСтроки.Выбрать();
		Пока ВыборкаСерийныеНомера.Следующий() Цикл
			
			Если КоличествоСН>=КоличествоЗаполнить Тогда
				Прервать;
			КонецЕсли;
			
			НовСтр = ДокОбъект[ИмяТЧСерийныеНомера].Добавить();
			НовСтр.СерийныйНомер = ВыборкаСерийныеНомера.СерийныйНомер;
			НовСтр.КлючСвязи = ВыборкаСерийныеНомера.КлючСвязи;
			
			КоличествоСН = КоличествоСН + 1;
			
		КонецЦикла;
		
		ДокОбъект[ИмяТЧЗапасы][ВыборкаНомерСтроки.НомерСтроки-1].СерийныеНомера = СтрокаСерийныеНомера(ДокОбъект[ИмяТЧСерийныеНомера], НовСтр.КлючСвязи);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверкаЗаполненияСерийныхНомеров(Отказ, Знач Запасы, Знач СерийныеНомера, СтруктурнаяЕдиница, Знач вхФорма, ИмяПоляКлючСвязи="КлючСвязи") Экспорт
	
	//Серийные номера
	ИспользованиеСерийныхНомеров = ИспользоватьСерийныеНомераОстатки();
	
	Если ИспользованиеСерийныхНомеров = Истина Тогда
	
		Для каждого СтрокаЗапасы Из Запасы Цикл
			
			//Не проверяем серийные номера на ордерном складе для маркируемой продукции
			Если ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктурнаяЕдиница,"ОрдерныйСклад") И СтрокаЗапасы.Номенклатура.ВидМаркировки = Перечисления.ВидыМаркировки.МаркируемаяПродукция Тогда
				Продолжить;
			КонецЕсли;
			
			Если СтрокаЗапасы.Номенклатура.ИспользоватьСерийныеНомера Тогда
				ОтборСерийныеНомера = Новый Структура("КлючСвязи", СтрокаЗапасы[ИмяПоляКлючСвязи]);
				ОтборСерийныеНомера = СерийныеНомера.НайтиСтроки(ОтборСерийныеНомера);
				
				Если ТипЗнч(СтрокаЗапасы.ЕдиницаИзмерения)=Тип("СправочникСсылка.ЕдиницыИзмерения") Тогда
				    Коэффициент = КоэффициентЕдиницы(СтрокаЗапасы.ЕдиницаИзмерения);
				Иначе
					Коэффициент = 1;
				КонецЕсли;
				
				СтрокаЗапасыКоличество = СтрокаЗапасы.Количество * Коэффициент;
				
				Если ОтборСерийныеНомера.Количество() <> СтрокаЗапасыКоличество Тогда
					ИмяТЧ = Сред(Строка(Запасы), СтрНайти(Строка(Запасы), ".", НаправлениеПоиска.СКонца)+1);
					ТекстСообщения = НСтр("ru = 'Число серийных номеров табличной части %ИмяТЧ% отличается от количества единиц в строке %Номер%.'");
					ТекстСообщения = ТекстСообщения + НСтр("ru = ' Серийных номеров - %ЧислоНомеров%, нужно %КоличествоВСтроке%'");
					ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Номер%", СтрокаЗапасы.НомерСтроки);
					ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ИмяТЧ%", ИмяТЧ);
					ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЧислоНомеров%", ОтборСерийныеНомера.Количество());
					ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КоличествоВСтроке%", СтрокаЗапасыКоличество);
					
					Сообщение = Новый СообщениеПользователю();
					Сообщение.Текст = ТекстСообщения;
					Сообщение.Сообщить();
					
					Отказ = Истина;
				КонецЕсли;
			КонецЕсли; 
		КонецЦикла;
	
	КонецЕсли; 
	
	Если ИспользованиеСерийныхНомеров <> Неопределено Тогда
	
		ВыполнитьКонтрольДублей(Отказ, Запасы, СерийныеНомера, вхФорма, ИмяПоляКлючСвязи);
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ВыполнитьКонтрольДублей(Отказ, Знач Запасы, Знач СерийныеНомера, Знач вхФорма, ИмяПоляКлючСвязи)
	
	// Проверка Дубли строк.
	Запрос = Новый Запрос();
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаДокумента.КлючСвязи КАК КлючСвязи,
	|	ТаблицаДокумента.СерийныйНомер
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	&ТаблицаДокумента КАК ТаблицаДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МАКСИМУМ(ТаблицаДокумента1.КлючСвязи) КАК КлючСвязи,
	|	ТаблицаДокумента1.СерийныйНомер
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента1
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ТаблицаДокумента КАК ТаблицаДокумента2
	|		ПО ТаблицаДокумента1.КлючСвязи <> ТаблицаДокумента2.КлючСвязи
	|			И ТаблицаДокумента1.СерийныйНомер = ТаблицаДокумента2.СерийныйНомер
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента1.СерийныйНомер
	|
	|УПОРЯДОЧИТЬ ПО
	|	КлючСвязи";
	
	Запрос.УстановитьПараметр("ТаблицаДокумента", СерийныеНомера);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если НЕ РезультатЗапроса.Пустой() Тогда
		ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
		Пока ВыборкаИзРезультатаЗапроса.Следующий() Цикл
			ТекстСообщения = НСтр(
				"ru = 'Серийный номер ""%СерийныйНомер%"", указанный в строке %НомерСтроки%, указан повторно.'"
			);
			
			НомерСтрокиЗапасов = Запасы.Найти(ВыборкаИзРезультатаЗапроса.КлючСвязи, ИмяПоляКлючСвязи);
			Если НомерСтрокиЗапасов<>Неопределено Тогда
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%НомерСтроки%", НомерСтрокиЗапасов.НомерСтроки);
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%СерийныйНомер%", ВыборкаИзРезультатаЗапроса.СерийныйНомер);
				УправлениеНебольшойФирмойСервер.СообщитьОбОшибке(
					вхФорма,
					ТекстСообщения,
					,
					,
					"СерийныеНомера",
					Отказ
				);
			КонецЕсли;
			

		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры
	
Процедура ПроверкаЗаполненияСерийныхНомеровВПолеВвода(Отказ, Знач Объект) Экспорт
	
	//Серийные номера
	Если ИспользоватьСерийныеНомераОстатки() = Истина Тогда
		
		Если Объект.Номенклатура.ИспользоватьСерийныеНомера Тогда
			
			Если ТипЗнч(Объект.ЕдиницаИзмерения)=Тип("СправочникСсылка.ЕдиницыИзмерения") Тогда
				Коэффициент = КоэффициентЕдиницы(Объект.ЕдиницаИзмерения);
			Иначе
				Коэффициент = 1;
			КонецЕсли;
			
			ОбъектКоличество = Объект.Количество * Коэффициент;
			
			Если Объект.СерийныеНомера.Количество() <> ОбъектКоличество Тогда
				ТекстСообщения = НСтр("ru = 'Число серийных номеров отличается от количества в документе.'");
				ТекстСообщения = ТекстСообщения + НСтр("ru = ' Серийных номеров - %ЧислоНомеров%, нужно %КоличествоВСтроке%'");
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ЧислоНомеров%", Объект.СерийныеНомера.Количество());
				ТекстСообщения = СтрЗаменить(ТекстСообщения, "%КоличествоВСтроке%", ОбъектКоличество);
				
				Сообщение = Новый СообщениеПользователю();
				Сообщение.Текст = ТекстСообщения;
				Сообщение.Сообщить();
				
				Отказ = Истина;
			КонецЕсли;
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Функция ИспользоватьСерийныеНомераОстатки() Экспорт
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьСерийныеНомера") Тогда
		Если ПолучитьФункциональнуюОпцию("КонтрольОстатковСерийныхНомеров") Тогда
			возврат Истина;
		Иначе
			возврат Ложь;
		КонецЕсли;
	Иначе
		возврат Неопределено;
	КонецЕсли;
	
КонецФункции

Функция ДобавитьСерийныйНомер(Номенклатура, ШаблонСерийногоНомера) Экспорт

	МаксимальныйНомерИзСправочника = Справочники.СерийныеНомера.ВычислитьМаксимальныйНомерСерии(Номенклатура, ШаблонСерийногоНомера);
	возврат ДобавитьСерийныйНомерПоШаблону(МаксимальныйНомерИзСправочника+1, ШаблонСерийногоНомера);
	
КонецФункции

Функция ДобавитьСерийныйНомерПоШаблону(ТекущийМаксимальныйНомер, ШаблонСерийногоНомера)
		
	НомерЧисло = ТекущийМаксимальныйНомер;
	
	Если ЗначениеЗаполнено(ШаблонСерийногоНомера) Тогда
		//Длина цифровой части номера - не более 13 символов
		ЦифрВШаблоне = СтрЧислоВхождений(ШаблонСерийногоНомера, РаботаССерийнымиНомерамиКлиентСервер.СимволЧисла());
		ЧислоСимволовСН = Макс(ЦифрВШаблоне, СтрДлина(НомерЧисло));
		НомерСНулями = Формат(НомерЧисло, "ЧЦ="+ЦифрВШаблоне+"; ЧВН=; ЧГ=");
		
		НовыйНомерПоШаблону = "";
		НомерСимволаСН = 1;
		//Заполняем шаблон
		Для н=1 По СтрДлина(ШаблонСерийногоНомера) Цикл
			симв = Сред(ШаблонСерийногоНомера,н,1);
			Если симв=РаботаССерийнымиНомерамиКлиентСервер.СимволЧисла() Тогда
				НовыйНомерПоШаблону = НовыйНомерПоШаблону+Сред(НомерСНулями,НомерСимволаСН,1);
				НомерСимволаСН = НомерСимволаСН+1;
			Иначе
				НовыйНомерПоШаблону = НовыйНомерПоШаблону+симв;
			КонецЕсли;
		КонецЦикла;
		НовыйНомер = НовыйНомерПоШаблону;
	Иначе
		НовыйНомер = Формат(НомерЧисло, "ЧЦ=8; ЧВН=; ЧГ=");
	КонецЕсли;
	
	возврат Новый Структура("НовыйНомер, НовыйНомерЧисло", НовыйНомер, НомерЧисло);
	
КонецФункции

Функция КоэффициентЕдиницы(ЕдиницаИзмерения) Экспорт
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЕдиницаИзмерения,"Коэффициент");
	
КонецФункции
