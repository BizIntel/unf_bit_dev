﻿
#Область РаботаСТабличнойЧастьюНоменклатуры

//Заполняет данные строки табличной части документа, выбранной из списка номенклатуры в новый документ
//Объект - заполняемый документ
//ИмяТабличнойЧасти - Имя табличной части документа, куда добавляется строка
//СтрокаТабличнойЧасти - заполняемая строка
Процедура ЗаполнитьДанныеВСтрокеТабличнойЧасти(Объект, ИмяТабличнойЧасти, СтрокаТабличнойЧасти) Экспорт
	
	СтруктураДанные = Новый Структура;
	СтруктураДанные.Вставить("Организация", Объект.Организация);
	СтруктураДанные.Вставить("Номенклатура", СтрокаТабличнойЧасти.Номенклатура);
	Если РаботаСНоменклатуройКлиентСервер.ЕстьРеквизитОбъекта("Характеристика", СтрокаТабличнойЧасти) Тогда
		СтруктураДанные.Вставить("Характеристика", СтрокаТабличнойЧасти.Характеристика);
	КонецЕсли;
	СтруктураДанные.Вставить("ДатаОбработки", ТекущаяДата());
	Если РаботаСНоменклатуройКлиентСервер.ЕстьРеквизитОбъекта("Коэффициент", СтрокаТабличнойЧасти) 
		И РаботаСНоменклатуройКлиентСервер.ЕстьРеквизитОбъекта("Кратность", СтрокаТабличнойЧасти) 
		Тогда
		СтруктураДанные.Вставить("НормаВремени", 1);
	КонецЕсли;
	Если РаботаСНоменклатуройКлиентСервер.ЕстьРеквизитОбъекта("НалогообложениеНДС", Объект) Тогда
		СтруктураДанные.Вставить("НалогообложениеНДС", Объект.НалогообложениеНДС);
	КонецЕсли;
	Если РаботаСНоменклатуройКлиентСервер.ЕстьРеквизитОбъекта("ВалютаДокумента", Объект) Тогда
		СтруктураДанные.Вставить("ВалютаДокумента", Объект.ВалютаДокумента);
	КонецЕсли;
	Если РаботаСНоменклатуройКлиентСервер.ЕстьРеквизитОбъекта("СуммаВключаетНДС", Объект) Тогда
		СтруктураДанные.Вставить("СуммаВключаетНДС", Объект.СуммаВключаетНДС);
	КонецЕсли;
	Если РаботаСНоменклатуройКлиентСервер.ЕстьРеквизитОбъекта("ВидЦен", Объект) И ЗначениеЗаполнено(Объект.ВидЦен) Тогда
		СтруктураДанные.Вставить("ВидЦен", Объект.ВидЦен);
	КонецЕсли; 
	Если РаботаСНоменклатуройКлиентСервер.ЕстьРеквизитОбъекта("ВидЦенКонтрагента", Объект) И ЗначениеЗаполнено(Объект.ВидЦенКонтрагента) Тогда
		СтруктураДанные.Вставить("ВидЦенКонтрагента", Объект.ВидЦенКонтрагента);
	КонецЕсли; 
	Если РаботаСНоменклатуройКлиентСервер.ЕстьРеквизитОбъекта("ЕдиницаИзмерения", Объект) И ТипЗнч(СтрокаТабличнойЧасти.ЕдиницаИзмерения)=Тип("СправочникСсылка.ЕдиницыИзмерения") Тогда
		СтруктураДанные.Вставить("Коэффициент", СтрокаТабличнойЧасти.ЕдиницаИзмерения.Коэффициент);
	Иначе
		СтруктураДанные.Вставить("Коэффициент", 1);
	КонецЕсли;
	Если РаботаСНоменклатуройКлиентСервер.ЕстьРеквизитОбъекта("ВидРабот", Объект) И ЗначениеЗаполнено(Объект.ВидРабот) Тогда
		СтруктураДанные.Вставить("ВидРабот", Объект.ВидРабот);
	КонецЕсли; 
	
	ИспользоватьСкидки = РаботаСНоменклатуройКлиентСервер.ЕстьРеквизитОбъекта("ВидСкидкиНаценки", Объект);
	Если ИспользоватьСкидки И ЗначениеЗаполнено(Объект.ВидСкидкиНаценки) Тогда
		СтруктураДанные.Вставить("ВидСкидкиНаценки", Объект.ВидСкидкиНаценки);
	КонецЕсли; 
	Если РаботаСНоменклатуройКлиентСервер.ЕстьРеквизитОбъекта("ДисконтнаяКарта", Объект) И ЗначениеЗаполнено(Объект.ДисконтнаяКарта) Тогда
		СтруктураДанные.Вставить("ДисконтнаяКарта", Объект.ДисконтнаяКарта);
		СтруктураДанные.Вставить("ПроцентСкидкиПоДисконтнойКарте", Объект.ПроцентСкидкиПоДисконтнойКарте);		
	КонецЕсли; 

	ДанныеЗаполненияСтроки = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);
	
	ЗаполнитьЗначенияСвойств(СтрокаТабличнойЧасти, ДанныеЗаполненияСтроки);
	
	Если РаботаСНоменклатуройКлиентСервер.ЕстьРеквизитОбъекта("Количество", СтрокаТабличнойЧасти) Тогда
		
		Если ИмяТабличнойЧасти = "Работы" Тогда
			
			СтрокаТабличнойЧасти.Количество = СтруктураДанные.НормаВремени;
			
			Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Кратность) Тогда
				СтрокаТабличнойЧасти.Кратность = 1;
			КонецЕсли;
			Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Коэффициент) Тогда
				СтрокаТабличнойЧасти.Коэффициент = 1;
			КонецЕсли;
			
			СтрокаТабличнойЧасти.ТипНоменклатурыУслуга = СтруктураДанные.ЭтоУслуга;
			
		ИначеЕсли ИмяТабличнойЧасти = "Запасы" Тогда
			
			Если РаботаСНоменклатуройКлиентСервер.ЕстьРеквизитОбъекта("ТипНоменклатурыЗапас", Объект) Тогда
				СтрокаТабличнойЧасти.ТипНоменклатурыЗапас = СтруктураДанные.ЭтоЗапас;
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ЕдиницаИзмерения) Тогда
				СтрокаТабличнойЧасти.ЕдиницаИзмерения = СтруктураДанные.БазоваяЕдиницаИзмерения;
			КонецЕсли;
			
		ИначеЕсли ИмяТабличнойЧасти = "МатериалыЗаказчика" Тогда
			
			Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.ЕдиницаИзмерения) Тогда
				СтрокаТабличнойЧасти.ЕдиницаИзмерения = СтруктураДанные.БазоваяЕдиницаИзмерения;
			КонецЕсли;
			
		КонецЕсли;
		
		РаботаСНоменклатуройКлиентСервер.РассчитатьСуммуВСтрокеТабличнойЧасти(Объект, СтрокаТабличнойЧасти, ИмяТабличнойЧасти = "Запасы");
		
	КонецЕсли;
		
КонецПроцедуры
	
Функция ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные)
	
	СтруктураДанные.Вставить("БазоваяЕдиницаИзмерения", СтруктураДанные.Номенклатура.ЕдиницаИзмерения);
	
	СтруктураДанные.Вставить("ЭтоУслуга", СтруктураДанные.Номенклатура.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Услуга"));
	СтруктураДанные.Вставить("ЭтоЗапас", СтруктураДанные.Номенклатура.ТипНоменклатуры = ПредопределенноеЗначение("Перечисление.ТипыНоменклатуры.Запас"));
	
	Если СтруктураДанные.Свойство("НормаВремени") Тогда
		СтруктураДанные.НормаВремени = УправлениеНебольшойФирмойСервер.ПолучитьНормуВремениРаботы(СтруктураДанные);
	КонецЕсли;
	
	Если СтруктураДанные.Свойство("НалогообложениеНДС")
		И НЕ СтруктураДанные.НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.ОблагаетсяНДС") Тогда
		
		Если СтруктураДанные.НалогообложениеНДС = ПредопределенноеЗначение("Перечисление.ТипыНалогообложенияНДС.НеОблагаетсяНДС") Тогда
			СтруктураДанные.Вставить("СтавкаНДС", УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСБезНДС());
		Иначе
			СтруктураДанные.Вставить("СтавкаНДС", УправлениеНебольшойФирмойПовтИсп.ПолучитьСтавкуНДСНоль());
		КонецЕсли;
		
	ИначеЕсли ЗначениеЗаполнено(СтруктураДанные.Номенклатура.СтавкаНДС) Тогда
		СтруктураДанные.Вставить("СтавкаНДС", СтруктураДанные.Номенклатура.СтавкаНДС);
	Иначе
		СтруктураДанные.Вставить("СтавкаНДС", СтруктураДанные.Организация.СтавкаНДСПоУмолчанию);
	КонецЕсли;
	
	Если СтруктураДанные.Свойство("Характеристика") Тогда
		СтруктураДанные.Вставить("Спецификация", УправлениеНебольшойФирмойСервер.ПолучитьПоУмолчаниюСпецификацию(СтруктураДанные.Номенклатура, СтруктураДанные.Характеристика));
	Иначе
		СтруктураДанные.Вставить("Спецификация", УправлениеНебольшойФирмойСервер.ПолучитьПоУмолчаниюСпецификацию(СтруктураДанные.Номенклатура));
	КонецЕсли;
	
	Если СтруктураДанные.Свойство("ВидЦен") Тогда
		
		Если НЕ СтруктураДанные.Свойство("Характеристика") Тогда
			СтруктураДанные.Вставить("Характеристика", Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка());
		КонецЕсли;
		Если НЕ СтруктураДанные.Свойство("ВалютаДокумента") И ЗначениеЗаполнено(СтруктураДанные.ВидЦен) Тогда
			//для ЗаданиеНаРаботу - у которого нет реквизита ВалютыДокумента
			СтруктураДанные.Вставить("ВалютаДокумента", СтруктураДанные.ВидЦен.ВалютаЦены);
		КонецЕсли;
		
		Если СтруктураДанные.Свойство("ВидРабот") Тогда
		
			Если СтруктураДанные.Номенклатура.ФиксированнаяСтоимость Тогда
				
				Цена = УправлениеНебольшойФирмойСервер.ПолучитьЦенуНоменклатурыПоВидуЦен(СтруктураДанные);
				СтруктураДанные.Вставить("Цена", Цена);
			
			Иначе
				
				ТекНоменклатура = СтруктураДанные.Номенклатура;
				СтруктураДанные.Номенклатура = СтруктураДанные.ВидРабот;
				СтруктураДанные.Характеристика = Справочники.ХарактеристикиНоменклатуры.ПустаяСсылка();
				Цена = УправлениеНебольшойФирмойСервер.ПолучитьЦенуНоменклатурыПоВидуЦен(СтруктураДанные);
				СтруктураДанные.Вставить("Цена", Цена);
				
				СтруктураДанные.Номенклатура = ТекНоменклатура;
				
			КонецЕсли;
		
		Иначе
			
			Цена = УправлениеНебольшойФирмойСервер.ПолучитьЦенуНоменклатурыПоВидуЦен(СтруктураДанные);
			СтруктураДанные.Вставить("Цена", Цена);
			
		КонецЕсли;
		
	Иначе
		
		СтруктураДанные.Вставить("Цена", 0);
		
	КонецЕсли;
	
	Если СтруктураДанные.Свойство("ВидСкидкиНаценки")
		И ЗначениеЗаполнено(СтруктураДанные.ВидСкидкиНаценки) Тогда
		СтруктураДанные.Вставить("ПроцентСкидкиНаценки", СтруктураДанные.ВидСкидкиНаценки.Процент);
	Иначе
		СтруктураДанные.Вставить("ПроцентСкидкиНаценки", 0);
	КонецЕсли;
	
	Если СтруктураДанные.Свойство("ПроцентСкидкиПоДисконтнойКарте") 
		И ЗначениеЗаполнено(СтруктураДанные.ДисконтнаяКарта) Тогда
		ТекПроцент = СтруктураДанные.ПроцентСкидкиНаценки;
		СтруктураДанные.Вставить("ПроцентСкидкиНаценки", ТекПроцент + СтруктураДанные.ПроцентСкидкиПоДисконтнойКарте);
	КонецЕсли;
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеНоменклатураПриИзменении()

Функция СформироватьГарантийныеТалоныДокумента(ТабличныйДокумент, ТекущийДокумент, Ошибки) Экспорт
	
	ИмяДокумента = ТекущийДокумент.Метаданные().Имя;
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДокПечати.Дата КАК ДатаДокумента,
	|	ДокПечати.Номер КАК Номер,
	|	ДокПечати.Организация.Префикс КАК Префикс,
	|	ДокПечати.Организация.ФайлЛоготип КАК ФайлЛоготип,
	|	ДокПечати.Ответственный.Физлицо КАК Ответственный,
	|	ДокПечати.УсловияГарантийногоТалона,
	|	ДокПечати.Запасы.(
	|		НомерСтроки КАК НомерСтроки,
	|		Номенклатура.ГарантийныйСрок КАК ГарантийныйСрок,
	|		Номенклатура.ВыписыватьГарантийныйТалон КАК ВыписыватьГарантийныйТалон,
	|		ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(ДокПечати.Запасы.Номенклатура.НаименованиеПолное КАК СТРОКА(100))) = """"
	|				ТОГДА ДокПечати.Запасы.Номенклатура.Наименование
	|			ИНАЧЕ ДокПечати.Запасы.Номенклатура.НаименованиеПолное
	|		КОНЕЦ КАК Запас,
	|		Номенклатура.Артикул КАК Артикул,
	|		Номенклатура.Код КАК Код,
	|		ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмерения,
	|		Количество КАК Количество,
	|		Характеристика,
	|		Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|		КлючСвязи
	|	),
	|	ДокПечати.Контрагент,
	|	ДокПечати.Организация,
	|	ДокПечати.СерийныеНомера.(
	|		СерийныйНомер,
	|		КлючСвязи
	|	)
	|ИЗ
	|	Документ."+ИмяДокумента+" КАК ДокПечати
	|ГДЕ
	|	ДокПечати.Ссылка = &ТекущийДокумент
	|	И ДокПечати.Запасы.Номенклатура.ВыписыватьГарантийныйТалон
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Шапка = Запрос.Выполнить().Выбрать();
	Если Шапка.Количество()=0 Тогда
		ТекстСообщения = Нстр("ru = '__________________
		|Документ %1.
		|В документе нет товаров с опцией <Выписывать гарантийный талон>'");
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ТекущийДокумент);
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, , ТекстСообщения, Неопределено);
		Возврат Неопределено;
	КонецЕсли;
	Шапка.Следующий();
	
	ВыборкаСтрокЗапасы = Шапка.Запасы.Выбрать();
	ВыборкаСтрокСерийныеНомера = Шапка.СерийныеНомера.Выбрать();
	
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ГарантийныйТалон";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_ГарантийныйТалон");
	
	НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.Номер, Истина, Истина);
	
	Если ЗначениеЗаполнено(Шапка.ФайлЛоготип) Тогда
		
		ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокСЛоготипом");
		
		ДанныеКартинки = ПрисоединенныеФайлы.ПолучитьДвоичныеДанныеФайла(Шапка.ФайлЛоготип);
		Если ЗначениеЗаполнено(ДанныеКартинки) Тогда
			
			ОбластьМакета.Рисунки.Логотип.Картинка = Новый Картинка(ДанныеКартинки);
			
		КонецЕсли;
		
	Иначе // Если картинки не выбраны печатаем обычный заголовок
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		
	КонецЕсли;
	
	ОбластьМакета.Параметры.ТекстЗаголовка = "Гарантийный талон № "
		+ НомерДокумента
		+ " от "
		+ Формат(Шапка.ДатаДокумента, "ДЛФ=DD");
	
	СведенияОбОрганизации = УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаДокумента);
	ОбластьМакета.Параметры.Организация = УправлениеНебольшойФирмойСервер.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование,ФактическийАдрес,Телефоны");
	ОбластьМакета.Параметры.Контрагент = Шапка.Контрагент;
	
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ТабличныйДокумент.Вывести(ОбластьМакета);
	ОбластьМакета = Макет.ПолучитьОбласть("Строка");
	
	НомерСтроки = 1;
	Пока ВыборкаСтрокЗапасы.Следующий() Цикл
		
		Если НЕ ВыборкаСтрокЗапасы.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Запас Тогда
			Продолжить;
		КонецЕсли;
		
		ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокЗапасы);
		ОбластьМакета.Параметры.НомерСтроки = НомерСтроки;
		
		СтрокаСерийныеНомера = РаботаССерийнымиНомерами.СтрокаСерийныеНомераИзВыборки(ВыборкаСтрокСерийныеНомера, ВыборкаСтрокЗапасы.КлючСвязи);
		ОбластьМакета.Параметры.Запас = УправлениеНебольшойФирмойСервер.ПолучитьПредставлениеНоменклатурыДляПечати(ВыборкаСтрокЗапасы.Запас, 
			ВыборкаСтрокЗапасы.Характеристика, ВыборкаСтрокЗапасы.Артикул, СтрокаСерийныеНомера);
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		НомерСтроки = НомерСтроки+1;
		
	КонецЦикла;
	
	ОбластьМакета = Макет.ПолучитьОбласть("Итого");
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("ДополнительныеУсловия");
	// Дополнительные условия
	Если ЗначениеЗаполнено(Шапка.УсловияГарантийногоТалона) И
		ЗначениеЗаполнено(Макет.Области.Найти("ДополнительныеУсловия")) Тогда
		
		ОбластьМакета = Макет.ПолучитьОбласть("ДополнительныеУсловия");
		
		// Добавим отступ перед текстом
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Выводим построчно многострочный текст
		// для того, чтобы корректно печатались длинные тексты
		ТекстДополнительныхУсловий = Шапка.УсловияГарантийногоТалона.ТекстУсловий;
		ЧислоСтрокТекста = СтрЧислоСтрок(ТекстДополнительныхУсловий);
		Для СчетчикСтрок = 1 По ЧислоСтрокТекста Цикл
			СтруктураПараметров = Новый Структура("ТекстДополнительныхУсловий", 
			СтрПолучитьСтроку(ТекстДополнительныхУсловий, СчетчикСтрок));
			ОбластьМакета.Параметры.Заполнить(СтруктураПараметров);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
	КонецЕсли;			
	
	ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция СформироватьГарантийныеТалоныПроизводство(ТабличныйДокумент, ТекущийДокумент, Ошибки, ИмяТЧПродукция="Продукция") Экспорт
	
	ИмяДокумента = ТекущийДокумент.Метаданные().Имя;
	
	ИмяТЧСерийныеНомера = "СерийныеНомера"+?(ИмяТЧПродукция="Продукция", "Продукция","");
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДокПечати.Дата КАК ДатаДокумента,
	|	ДокПечати.Номер КАК Номер,
	|	ДокПечати.Организация.Префикс КАК Префикс,
	|	ДокПечати.Организация.ФайлЛоготип КАК ФайлЛоготип,
	|	ДокПечати.Автор.ФизическоеЛицо КАК Ответственный,
	|	ДокПечати.УсловияГарантийногоТалона,
	|	ДокПечати."+ИмяТЧПродукция+".(
	|		НомерСтроки КАК НомерСтроки,
	|		Номенклатура.ГарантийныйСрок КАК ГарантийныйСрок,
	|		Номенклатура.ВыписыватьГарантийныйТалон КАК ВыписыватьГарантийныйТалон,
	|		ВЫБОР
	|			КОГДА (ВЫРАЗИТЬ(ДокПечати."+ИмяТЧПродукция+".Номенклатура.НаименованиеПолное КАК СТРОКА(100))) = """"
	|				ТОГДА ДокПечати."+ИмяТЧПродукция+".Номенклатура.Наименование
	|			ИНАЧЕ ДокПечати."+ИмяТЧПродукция+".Номенклатура.НаименованиеПолное
	|		КОНЕЦ КАК Запас,
	|		Номенклатура.Артикул КАК Артикул,
	|		Номенклатура.Код КАК Код,
	|		ЕдиницаИзмерения.Наименование КАК ЕдиницаИзмерения,
	|		Количество КАК Количество,
	|		Характеристика,
	|		Номенклатура.ТипНоменклатуры КАК ТипНоменклатуры,
	|		КлючСвязи
	|	),
	|	ДокПечати.ЗаказПокупателя.Контрагент КАК Контрагент,
	|	ДокПечати.Организация,
	|	ДокПечати."+ИмяТЧСерийныеНомера+".(
	|		СерийныйНомер,
	|		КлючСвязи
	|	)
	|ИЗ
	|	Документ.СборкаЗапасов КАК ДокПечати
	|ГДЕ
	|	ДокПечати.Ссылка = &ТекущийДокумент
	|	И ДокПечати."+ИмяТЧПродукция+".Номенклатура.ВыписыватьГарантийныйТалон
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Шапка = Запрос.Выполнить().Выбрать();
	Если Шапка.Количество()=0 Тогда
		ТекстСообщения = Нстр("ru = '__________________
		|Документ %1.
		|В документе нет товаров с опцией <Выписывать гарантийный талон>'");
		
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстСообщения, ТекущийДокумент);
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, , ТекстСообщения, Неопределено);
		Возврат Неопределено;
	КонецЕсли;
	Шапка.Следующий();
	
	ВыборкаСтрокЗапасы = Шапка[ИмяТЧПродукция].Выбрать();
	ВыборкаСтрокСерийныеНомера = Шапка[ИмяТЧСерийныеНомера].Выбрать();
	
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ГарантийныйТалон";
	
	Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_ГарантийныйТалон");
	
	НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.Номер, Истина, Истина);
	
	Если ЗначениеЗаполнено(Шапка.ФайлЛоготип) Тогда
		
		ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокСЛоготипом");
		
		ДанныеКартинки = ПрисоединенныеФайлы.ПолучитьДвоичныеДанныеФайла(Шапка.ФайлЛоготип);
		Если ЗначениеЗаполнено(ДанныеКартинки) Тогда
			
			ОбластьМакета.Рисунки.Логотип.Картинка = Новый Картинка(ДанныеКартинки);
			
		КонецЕсли;
		
	Иначе // Если картинки не выбраны печатаем обычный заголовок
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		
	КонецЕсли;
	
	ОбластьМакета.Параметры.ТекстЗаголовка = НСтр("ru = 'Гарантийный талон'")+" № "+НомерДокумента+НСтр("ru = ' от'")+" ___________________";
	//Дату продажи не указываем
	
	СведенияОбОрганизации = УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаДокумента);
	ОбластьМакета.Параметры.Организация = УправлениеНебольшойФирмойСервер.ОписаниеОрганизации(СведенияОбОрганизации, "ПолноеНаименование,ФактическийАдрес,Телефоны");
	ОбластьМакета.Параметры.Контрагент = Шапка.Контрагент;
	
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ТабличныйДокумент.Вывести(ОбластьМакета);
	ОбластьМакета = Макет.ПолучитьОбласть("Строка");
	
	НомерСтроки = 1;
	Пока ВыборкаСтрокЗапасы.Следующий() Цикл
		
		Если НЕ ВыборкаСтрокЗапасы.ТипНоменклатуры = Перечисления.ТипыНоменклатуры.Запас Тогда
			Продолжить;
		КонецЕсли;
		
		ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокЗапасы);
		ОбластьМакета.Параметры.НомерСтроки = НомерСтроки;
		
		СтрокаСерийныеНомера = РаботаССерийнымиНомерами.СтрокаСерийныеНомераИзВыборки(ВыборкаСтрокСерийныеНомера, ВыборкаСтрокЗапасы.КлючСвязи);
		ОбластьМакета.Параметры.Запас = УправлениеНебольшойФирмойСервер.ПолучитьПредставлениеНоменклатурыДляПечати(ВыборкаСтрокЗапасы.Запас, 
			ВыборкаСтрокЗапасы.Характеристика, ВыборкаСтрокЗапасы.Артикул, СтрокаСерийныеНомера);
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		НомерСтроки = НомерСтроки+1;
		
	КонецЦикла;
	
	ОбластьМакета = Макет.ПолучитьОбласть("Итого");
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("ДополнительныеУсловия");
	// Дополнительные условия
	Если ЗначениеЗаполнено(Шапка.УсловияГарантийногоТалона) И
		ЗначениеЗаполнено(Макет.Области.Найти("ДополнительныеУсловия")) Тогда
		
		ОбластьМакета = Макет.ПолучитьОбласть("ДополнительныеУсловия");
		
		// Добавим отступ перед текстом
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Выводим построчно многострочный текст
		// для того, чтобы корректно печатались длинные тексты
		ТекстДополнительныхУсловий = Шапка.УсловияГарантийногоТалона.ТекстУсловий;
		ЧислоСтрокТекста = СтрЧислоСтрок(ТекстДополнительныхУсловий);
		Для СчетчикСтрок = 1 По ЧислоСтрокТекста Цикл
			СтруктураПараметров = Новый Структура("ТекстДополнительныхУсловий", 
			СтрПолучитьСтроку(ТекстДополнительныхУсловий, СчетчикСтрок));
			ОбластьМакета.Параметры.Заполнить(СтруктураПараметров);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЦикла;
	КонецЕсли;			
	
	ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
	ОбластьМакета.Параметры.Заполнить(Шапка);
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	Возврат ТабличныйДокумент;
	
КонецФункции

Функция ПечатьГарантийныйТалон(МассивОбъектов, ОбъектыПечати) Экспорт
	
	Перем Ошибки;
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ПервыйДокумент = Истина;
	
	Для Каждого ТекущийДокумент Из МассивОбъектов Цикл
	
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		СформироватьГарантийныеТалоныДокумента(ТабличныйДокумент, ТекущийДокумент, Ошибки);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки);
	
	Возврат ТабличныйДокумент;
	
КонецФункции
	
#КонецОбласти

#Область ОбновлениеОстатков

Процедура ОбновитьОстаткиНоменклатурыВФоне() Экспорт
	
	ВнешняяТранзакция = ТранзакцияАктивна();
	Если НЕ ВнешняяТранзакция Тогда
		НачатьТранзакцию();
	КонецЕсли;
	
	// Тут будут ждать другие фоновые задания.
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.ОстаткиТоваров");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	Блокировка.Заблокировать();
	
	// Запрос возвращает разницу между регистром сведений ОстаткиТоваров и регистром накопления ЗапасыНаСкладах.
	// В запросе нельзя использовать ПОЛНОЕ СОЕДИНЕНИЕ из-за ограничений при работе на СУБД Postgresql.
	// Запрос корректно отрабатывает номенклатуру, которой нет в остатках РН, но есть в регистре сведений.
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	| ВложенныйЗапрос.Номенклатура КАК Номенклатура,
	| СУММА(ВложенныйЗапрос.КоличествоОстаток) КАК Количество
	|ИЗ
	| (ВЫБРАТЬ
	|  ЗапасыНаСкладахОстатки.Номенклатура КАК Номенклатура,
	|  ЗапасыНаСкладахОстатки.КоличествоОстаток КАК КоличествоОстаток,
	|  0 КАК Количество
	| ИЗ
	|  РегистрНакопления.ЗапасыНаСкладах.Остатки КАК ЗапасыНаСкладахОстатки
	| 
	| ОБЪЕДИНИТЬ ВСЕ
	| 
	| ВЫБРАТЬ
	|  ОстаткиТоваров.Номенклатура,
	|  0,
	|  ОстаткиТоваров.Количество
	| ИЗ
	|  РегистрСведений.ОстаткиТоваров КАК ОстаткиТоваров) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	| ВложенныйЗапрос.Номенклатура
	|
	|ИМЕЮЩИЕ
	| СУММА(ВложенныйЗапрос.КоличествоОстаток) <> СУММА(ВложенныйЗапрос.Количество)"; 
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НаборЗаписей = РегистрыСведений.ОстаткиТоваров.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Номенклатура.Установить(Выборка.Номенклатура);
		
		Запись = НаборЗаписей.Добавить();
		Запись.Номенклатура = Выборка.Номенклатура;
		Запись.Количество = Выборка.Количество;
		
		НаборЗаписей.Записать(Истина);
		
	КонецЦикла;
	
	Если НЕ ВнешняяТранзакция Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти