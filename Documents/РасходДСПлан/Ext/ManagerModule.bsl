﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Процедура формирования таблицы платежного календаря.
//
// Параметры:
//	ДокументСсылка - ДокументСсылка.ПриходДенежныхСредствПлан - Текущий документ
//	ДополнительныеСвойства - ДополнительныеСвойства - Дополнительные свойства документа
//
Процедура СформироватьТаблицаПлатежныйКалендарь(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ТаблицаДокумента.СтатьяДвиженияДенежныхСредств КАК Статья,
	|	ТаблицаДокумента.ТипДенежныхСредств КАК ТипДенежныхСредств,
	|	ТаблицаДокумента.СтатусУтвержденияПлатежа КАК СтатусУтвержденияПлатежа,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Наличные)
	|			ТОГДА ТаблицаДокумента.Касса
	|		КОГДА ТаблицаДокумента.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Безналичные)
	|			ТОГДА ТаблицаДокумента.БанковскийСчет
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК БанковскийСчетКасса,
	|	&Ссылка КАК СчетНаОплату,
	|	ТаблицаДокумента.ВалютаДокумента КАК Валюта,
	|	-ТаблицаДокумента.СуммаДокумента КАК Сумма
	|ИЗ
	|	Документ.РасходДСПлан КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПлатежныйКалендарь", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаПлатежныйКалендарь()

// Формирует таблицу данных документа.
//
// Параметры:
//	ДокументСсылка - ДокументСсылка.ПриходДенежныхСредствПлан - Текущий документ
//	СтруктураДополнительныеСвойства - ДополнительныеСвойства - Дополнительные свойства документа
//	
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	СформироватьТаблицаПлатежныйКалендарь(ДокументСсылка, СтруктураДополнительныеСвойства);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

#Область ВерсионированиеОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область ИнтерфейсПечати

// Процедура формирует и выводит печатную форму документа по указанному макету.
//
// Параметры:
//	ТабличныйДокумент - ТабличныйДокумент в который будет выводится печатная
//				   форма.
//  ИмяМакета    - Строка, имя макета печатной формы.
//
Процедура СформироватьПланированиеРасходаДС(ТабличныйДокумент, МассивОбъектов, ОбъектыПечати)
	
	ПервыйДокумент = Истина;
	ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РасходДСПлан_ПланированиеРасходовДС";
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.РасходДСПлан.ПФ_MXL_ПланированиеРасходовДС");
	
	СтруктураЗаполненияСекции = Новый Структура;
	Для Каждого ТекущийДокумент Из МассивОбъектов Цикл
		
		Если НЕ ПервыйДокумент Тогда
			
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			
		КонецЕсли;
		
		ПервыйДокумент = Ложь;
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПланРасходаДС.Ссылка
		|	,ПланРасходаДС.Номер КАК Номер
		|	,ПланРасходаДС.Дата КАК ДатаДокумента
		|	,ПланРасходаДС.Организация КАК Организация
		|	,ПланРасходаДС.Организация.Префикс КАК Префикс
		|	,ПланРасходаДС.СуммаДокумента КАК Сумма
		|	,ПланРасходаДС.ВалютаДокумента КАК Валюта
		|	,Представление(ПланРасходаДС.СтатьяДвиженияДенежныхСредств) КАК СтатьяДДС
		|	,Выразить(ПланРасходаДС.Комментарий КАК Строка(1000)) КАК Комментарий
		|	,ПланРасходаДС.ТипДенежныхСредств КАК ТипДС
		|	,ПланРасходаДС.БанковскийСчет.Код КАК НомерРС
		|	,ПланРасходаДС.Касса КАК Касса
		|	,Представление(ПланРасходаДС.ДокументОснование) КАК ОписаниеОснования
		|	,Выбор 
		|		Когда ПланРасходаДС.Проведен И ПланРасходаДС.СтатусУтвержденияПлатежа = Значение(Перечисление.СтатусыУтвержденияПлатежей.Утвержден) Тогда Истина
		|		Иначе Ложь
		|		Конец КАК ЗаявкаУтверждена
		|	,ПланРасходаДС.НомерВходящегоДокумента
		|	,ПланРасходаДС.ДатаВходящегоДокумента
		|	,ПланРасходаДС.Контрагент КАК Контрагент
		|	,ПланРасходаДС.Договор КАК Договор
		|	,ПланРасходаДС.Автор
		|ИЗ
		|	Документ.РасходДСПлан КАК ПланРасходаДС
		|ГДЕ
		|	ПланРасходаДС.Ссылка = &ТекущийДокумент";
		Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент);
		ДанныеДокумента = Запрос.Выполнить().Выбрать();
		ДанныеДокумента.Следующий();
		
		//:::Утверждено, отступ
		ОбластьМакета = Макет.ПолучитьОбласть(?(ДанныеДокумента.ЗаявкаУтверждена, "Утверждено", "Отступ"));
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		//:::Шапка
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		СтруктураЗаполненияСекции.Очистить();
		
		НомерДокумента = УправлениеНебольшойФирмойСервер.ПолучитьНомерНаПечатьСУчетомДатыДокумента(ДанныеДокумента.ДатаДокумента, ДанныеДокумента.Номер, ДанныеДокумента.Префикс);
		ДатаДокумента = Формат(ДанныеДокумента.ДатаДокумента, "ДФ='дд ММММ гггг'");
		Заголовок = НСтр("ru ='Планирование расхода денежных средств № '") + НомерДокумента + НСтр("ru =' от '") + ДатаДокумента;
		СтруктураЗаполненияСекции.Вставить("Заголовок", Заголовок);
		ОбластьМакета.Параметры.Заполнить(СтруктураЗаполненияСекции);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		//:::Строка
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		СтруктураЗаполненияСекции.Очистить();
		
		СтруктураЗаполненияСекции.Вставить("СтатьяДДС", ДанныеДокумента.СтатьяДДС);
		СтруктураЗаполненияСекции.Вставить("Комментарий", ДанныеДокумента.Комментарий);
		СтруктураЗаполненияСекции.Вставить("ОписаниеСуммы", Формат(ДанныеДокумента.Сумма, "ЧЦ=15; ЧДЦ=2; ЧРД=.") + ", " + ДанныеДокумента.Валюта);
		
		ОбластьМакета.Параметры.Заполнить(СтруктураЗаполненияСекции);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		//:::Подвал
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		СтруктураЗаполненияСекции.Очистить();
		
		СтруктураЗаполненияСекции.Вставить("СуммаПрописью", РаботаСКурсамиВалют.СформироватьСуммуПрописью(ДанныеДокумента.Сумма, ДанныеДокумента.Валюта));
		СтруктураЗаполненияСекции.Вставить("ОписаниеОснования", ДанныеДокумента.ОписаниеОснования);
		СтруктураЗаполненияСекции.Вставить("ОписаниеКонтрагента", ДанныеДокумента.Контрагент);
		
		ОписаниеИсточникаФинансирования = "";
		Если ДанныеДокумента.ТипДС = Перечисления.ТипыДенежныхСредств.Безналичные Тогда
			
			ОписаниеИсточникаФинансирования = НСтр("ru ='расчетный счет организации № '") + ДанныеДокумента.НомерРС;
			
		ИначеЕсли ДанныеДокумента.ТипДС = Перечисления.ТипыДенежныхСредств.Безналичные Тогда
			
			ОписаниеИсточникаФинансирования = НСтр("ru ='касса организации '") + ДанныеДокумента.Касса;
			
		КонецЕсли;
		СтруктураЗаполненияСекции.Вставить("ОписаниеИсточникаФинансирования", ОписаниеИсточникаФинансирования);
		
		ОбластьМакета.Параметры.Заполнить(СтруктураЗаполненияСекции);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		//:::Подпись
		ОбластьМакета = Макет.ПолучитьОбласть("Подпись");
		СтруктураЗаполненияСекции.Очистить();
		
		ОтветственныеЛица = УправлениеНебольшойФирмойСервер.ОтветственныеЛицаОрганизационнойЕдиницы(ДанныеДокумента.Организация, ДанныеДокумента.ДатаДокумента);
		СтруктураЗаполненияСекции.Вставить("РуководительДолжность", ОтветственныеЛица.РуководительДолжность);
		СтруктураЗаполненияСекции.Вставить("ГлБухгалтерДолжность", ОтветственныеЛица.ГлавныйБухгалтерДолжность);
		СтруктураЗаполненияСекции.Вставить("РуководительФИО", ОтветственныеЛица.ФИОРуководителя);
		СтруктураЗаполненияСекции.Вставить("ГлБухгалтерФИО", ОтветственныеЛица.ФИОГлавногоБухгалтера);
		
		ОбластьМакета.Параметры.Заполнить(СтруктураЗаполненияСекции);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент.Ссылка);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
КонецПроцедуры // СформироватьПланированиеРасходаДС()

// Сформировать печатные формы объектов
//
// ВХОДЯЩИЕ:
//   ИменаМакетов    - Строка    - Имена макетов, перечисленные через запятую
//   МассивОбъектов  - Массив    - Массив ссылок на объекты которые нужно распечатать
//   ПараметрыПечати - Структура - Структура дополнительных параметров печати
//
// ИСХОДЯЩИЕ:
//   КоллекцияПечатныхФорм - Таблица значений - Сформированные табличные документы
//   ПараметрыВывода       - Структура        - Параметры сформированных табличных документов
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПланированиеРасходовДС") Тогда
		
		СформироватьПланированиеРасходаДС(ТабличныйДокумент, МассивОбъектов, ОбъектыПечати);
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПланированиеРасходовДС", "Планирование расходов ДС", ТабличныйДокумент);
		
	КонецЕсли;
	
	// параметры отправки печатных форм по электронной почте
	УправлениеНебольшойФирмойСервер.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов, КоллекцияПечатныхФорм);

КонецПроцедуры

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "ПланированиеРасходовДС";
	КомандаПечати.Представление = НСтр("ru = 'Планирование расходов ДС'");
	КомандаПечати.СписокФорм = "ФормаДокумента,ФормаСписка";
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок = 1;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли