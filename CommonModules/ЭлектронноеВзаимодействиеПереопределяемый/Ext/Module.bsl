﻿////////////////////////////////////////////////////////////////////////////////
// ЭлектронноеВзаимодействиеПереопределяемый: общий механизм обмена электронными документами.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Изменяет поведение элементов управляемой или обычной формы.
//
// Параметры:
//  Форма - <Управляемая или обычная форма> - управляемая или обычная форма для изменения.
//  СтруктураПараметров - <Структура> - параметры процедуры
//
Процедура ИзменитьСвойстваЭлементовФормы(Форма, СтруктураПараметров) Экспорт
	
	Если СтруктураПараметров.Свойство("ВидОперации")
		И СтруктураПараметров.Свойство("ЗначениеПараметра") Тогда
		
		Если ВРег(СтруктураПараметров.ВидОперации) = ВРег("УстановкаГиперссылки")
			И СтруктураПараметров.Свойство("ТекстСостоянияЭД") Тогда
			
			// Зададим особые условия.
			Если СтрНайти(СтруктураПараметров.ТекстСостоянияЭД, "Не сформирован") > 0 Тогда
				
				СтруктураПараметров.ЗначениеПараметра = Ложь;
				
			КонецЕсли;
			
			// Определим элемент формы.
			НайденныйЭлементФормы = Неопределено;
			Если ТипЗнч(Форма) = Тип("УправляемаяФорма") Тогда // только для управляемой формы
				
				Если НЕ Форма.Элементы.Найти("СостояниеЭД") = Неопределено Тогда
					
					НайденныйЭлементФормы = Форма.Элементы.СостояниеЭД;
					
				КонецЕсли;
				
				// Заполним свойство найденного элемента.
				Если НЕ НайденныйЭлементФормы = Неопределено
					И НайденныйЭлементФормы.Вид = ВидПоляФормы.ПолеНадписи Тогда
					
					НайденныйЭлементФормы.Гиперссылка = СтруктураПараметров.ЗначениеПараметра;
					
				КонецЕсли;
				
			Иначе // для обычной формы
				
				Если НЕ Форма.ЭлементыФормы.Найти("ТекстСостоянияЭД") = Неопределено Тогда
					
					НайденныйЭлементФормы = Форма.ЭлементыФормы.ТекстСостоянияЭД;
					
				КонецЕсли;
				
				// Заполним свойство найденного элемента.
				Если НЕ НайденныйЭлементФормы = Неопределено
					И ТипЗнч(НайденныйЭлементФормы) = Тип("Надпись") Тогда
					
					НайденныйЭлементФормы.Гиперссылка = СтруктураПараметров.ЗначениеПараметра;
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипЗнч(Форма) = Тип("УправляемаяФорма") Тогда // только для управляемой формы
		
		Если НЕ ЕстьПравоЧтенияЭД() Тогда
			
			Если НЕ Форма.Элементы.Найти("ГруппаСостояниеЭД") = Неопределено Тогда
				
				Форма.Элементы.ГруппаСостояниеЭД.Видимость = Ложь;
				
			ИначеЕсли НЕ Форма.Элементы.Найти("СостояниеЭД") = Неопределено Тогда
				
				Форма.Элементы.СостояниеЭД.Видимость = Ложь;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// При необходимости, в функции можно определить каталог для временных файлов,
// отличный от устанавливаемого по умолчанию в библиотеке ЭД.
//
// Параметры:
//  ТекущийКаталог - путь к каталогу временных файлов.
//
Процедура ТекущийКаталогВременныхФайлов(ТекущийКаталог) Экспорт
	
	ТекущийКаталог = КаталогВременныхФайлов();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработка метаданных

// Определяет соответствие функциональных опций библиотеки и прикладного решения,
// в случае различий в наименовании.
//
// Параметры:
//  СоответствиеФО - Соответствие - список функциональных опций.
//
Процедура ПолучитьСоответствиеФункциональныхОпций(СоответствиеФО) Экспорт
	
	// Электронные документы
	СоответствиеФО.Вставить("ИспользоватьОбменЭД",                    "ИспользоватьОбменЭД");
	СоответствиеФО.Вставить("ИспользоватьЭлектронныеПодписи", 		  "ИспользоватьЭлектронныеПодписи");
	СоответствиеФО.Вставить("ИспользоватьЭлектронныеЦифровыеПодписи", "ИспользоватьЭлектронныеПодписи");
	СоответствиеФО.Вставить("ИспользоватьОбменЭДМеждуОрганизациями",  "ИспользоватьОбменЭДМеждуОрганизациями");
	СоответствиеФО.Вставить("ИспользоватьОбменСБанками",              "ИспользоватьОбменСБанками");
	// Конец электронные документы
	
КонецПроцедуры

// Определяет соответствие справочников библиотеки и прикладного решения,
// в случае различий в наименовании справочников.
//
// Параметры:
//  СоответствиеСправочников - Соответствие - список справочников.
//
Процедура ПолучитьСоответствиеСправочников(СоответствиеСправочников) Экспорт
	
	// Электронные документы
	СоответствиеСправочников.Вставить("Организации", "Организации");
	СоответствиеСправочников.Вставить("Контрагенты", "Контрагенты");
	СоответствиеСправочников.Вставить("Партнеры",    "Контрагенты");
	СоответствиеСправочников.Вставить("Банки",       "Банки");
	// Конец электронные документы
	
	СоответствиеСправочников.Вставить("ДоговорыКонтрагентов",        "ДоговорыКонтрагентов");
	СоответствиеСправочников.Вставить("Номенклатура",                "Номенклатура");
	СоответствиеСправочников.Вставить("ХарактеристикиНоменклатуры",  "ХарактеристикиНоменклатуры");
	СоответствиеСправочников.Вставить("ЕдиницыИзмерения",            "ЕдиницыИзмерения");
	СоответствиеСправочников.Вставить("НоменклатураПоставщиков",     "НоменклатураПоставщиков");
	СоответствиеСправочников.Вставить("Валюты",                      "Валюты");
	СоответствиеСправочников.Вставить("Банки", "Банки");
	СоответствиеСправочников.Вставить("БанковскиеСчетаОрганизаций",  "БанковскиеСчета");
	СоответствиеСправочников.Вставить("БанковскиеСчетаКонтрагентов", "БанковскиеСчета");
	СоответствиеСправочников.Вставить("УпаковкиНоменклатуры",        "ЕдиницыИзмерения");
	
КонецПроцедуры

// В процедуре формируется соответствие для сопоставления имен переменных библиотеки,
// наименованиям объектов и реквизитов метаданных прикладного решения.
// Если в прикладном решении есть документы, на основании которых формируется ЭД,
// причем названия реквизитов данных документов отличаются от общепринятых "Организация", "Контрагент", "СуммаДокумента",
// то для этих реквизитов необходимо добавить в соответствие записи виде
// Ключ = "ДокументВМетаданных.ОбщепринятоеНазваниеРеквизита", Значение - "ДокументВМетаданных.ДругоеНазваниеРеквизита"
// Например:
//  СоответствиеРеквизитовОбъекта.Вставить("МЗ_Покупка.Организация", "МЗ_Покупка.Учреждение");
//  СоответствиеРеквизитовОбъекта.Вставить("МЗ_Покупка.Контрагент",  "МЗ_Покупка.Грузоотправитель");
//  СоответствиеРеквизитовОбъекта.Вставить("СчетФактураВыданный.СуммаДокумента",  "СчетФактураВыданный.Основание.СуммаДокумента");
// 
// Параметры:
// СоответствиеРеквизитовОбъекта - Соответствие, в котором
//    * Ключ - Строка - имя переменной, используемой в коде библиотеки;
//    * Значение - Строка - наименование объекта метаданных или реквизита объекта в прикладном решении.
//
Процедура ПолучитьСоответствиеНаименованийОбъектовМДиРеквизитов(СоответствиеРеквизитовОбъекта) Экспорт
	
	// Обмен с банками начало
	СоответствиеРеквизитовОбъекта.Вставить("ПлатежноеПоручениеВМетаданных", "ПлатежноеПоручение");
	СоответствиеРеквизитовОбъекта.Вставить("СокращенноеНаименованиеОрганизации", "Наименование");
	// Обмен с банками конец
	
	// Обмен с контрагентами начало
	
	СоответствиеРеквизитовОбъекта.Вставить("СчетФактураВыданныйВМетаданных",       "СчетФактура");
	СоответствиеРеквизитовОбъекта.Вставить("СчетФактураПолученныйВМетаданных",     "СчетФактураПолученный");
	СоответствиеРеквизитовОбъекта.Вставить("РеализацияТоваровУслугВМетаданных",    "РасходнаяНакладная");
	СоответствиеРеквизитовОбъекта.Вставить("ПоступлениеТоваровУслугВМетаданных",   "ПриходнаяНакладная");
	СоответствиеРеквизитовОбъекта.Вставить("ДатаВыставленияВСчетеФактуреВыданном", "ДатаВыставления");
	СоответствиеРеквизитовОбъекта.Вставить("ДатаПолученияВСчетеФактуреПолученном", "Дата");
	СоответствиеРеквизитовОбъекта.Вставить("НомерСчета",                           "НомерСчета");
	
	СоответствиеРеквизитовОбъекта.Вставить("ИННКонтрагента",                       "ИНН");
	СоответствиеРеквизитовОбъекта.Вставить("КППКонтрагента",                       "КПП");
	СоответствиеРеквизитовОбъекта.Вставить("НаименованиеКонтрагента",              "Наименование");
	СоответствиеРеквизитовОбъекта.Вставить("НаименованиеКонтрагентаДляСообщенияПользователю", "Наименование");
	СоответствиеРеквизитовОбъекта.Вставить("ВнешнийКодКонтрагента",                "Код");
	СоответствиеРеквизитовОбъекта.Вставить("ПартнерКонтрагента",                   Неопределено);
	
	СоответствиеРеквизитовОбъекта.Вставить("ИННОрганизации",                       "ИНН");
	СоответствиеРеквизитовОбъекта.Вставить("КППОрганизации",                       "КПП");
	СоответствиеРеквизитовОбъекта.Вставить("ОГРНОрганизации",                      "ОГРН");
	СоответствиеРеквизитовОбъекта.Вставить("НаименованиеОрганизации",              "Наименование");
	СоответствиеРеквизитовОбъекта.Вставить("СокращенноеНаименованиеОрганизации",   "Наименование");
	// Обмен с контрагентами конец
	
КонецПроцедуры

// Заполняет соответствие кодов реквизитов схем электронных документов их пользовательскому представлению.
//
// Параметры:
//  СоответствиеВозврата - Соответствие, исходное соответствие для заполнения.
//
Процедура СоответствиеКодовРеквизитовИПредставлений(СоответствиеВозврата) Экспорт
	
	Макет = Обработки.ОбменСКонтрагентами.ПолучитьМакет("ПрикладноеПредставлениеРеквизитов");
	ВысотаТаблицы = Макет.ВысотаТаблицы;
	Для НСтр = 1 По ВысотаТаблицы Цикл
		СоответствиеВозврата.Вставить(СокрЛП(Макет.Область(НСтр, 1).Текст), СокрЛП(Макет.Область(НСтр,2).Текст));
	КонецЦикла;
	
КонецПроцедуры

// Получает ключевые реквизиты объекта по текстовому представлению.
//
// Параметры:
//  ИмяОбъекта - Строка, текстовое представление объекта, ключевые реквизиты которого необходимо получить.
//
// Возвращаемое значение:
//  СтруктураКлючевыхРеквизитов - перечень параметров объекта.
//
Процедура ПолучитьСтруктуруКлючевыхРеквизитовОбъекта(ИмяОбъекта, СтруктураКлючевыхРеквизитов) Экспорт
	
	Если ИмяОбъекта = "Документ.РасходнаяНакладная" Тогда
		// шапка
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, Контрагент");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		
		// ТЧ
		СтрокаРеквизитовОбъекта = ("Номенклатура, Количество, Цена, Сумма, СтавкаНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Запасы", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.ПриходнаяНакладная" Тогда
		// шапка
		СтрокаРеквизитовОбъекта = ("Организация, Контрагент");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		
		// ТЧ
		СтрокаРеквизитовОбъекта = ("Номенклатура, Количество, Цена, Сумма, СтавкаНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Запасы", СтрокаРеквизитовОбъекта);
		СтрокаРеквизитовОбъекта = ("Номенклатура, Количество, Цена, Сумма, СтавкаНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Расходы", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.ЗаказПоставщику" Тогда
		// шапка
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, Контрагент");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		
		// ТЧ
		СтрокаРеквизитовОбъекта = ("Номенклатура, Количество, Цена, Сумма, СтавкаНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Запасы", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.ЗаказПокупателя" Тогда
		// шапка
		СтрокаРеквизитовОбъекта = ("Организация, Контрагент");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		
		// ТЧ
		СтрокаРеквизитовОбъекта = ("Номенклатура, Количество, Цена, Сумма, СтавкаНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Запасы", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.СчетФактура" Тогда
		// шапка
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, СуммаДокумента");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.СчетФактураПолученный" Тогда
		// шапка
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, СуммаДокумента");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.КорректировкаРеализации" Тогда
		// шапка
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, Контрагент");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		
		// ТЧ
		СтрокаРеквизитовОбъекта = ("Номенклатура, Количество, Цена, Сумма, СтавкаНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Запасы", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.КорректировкаПоступления" Тогда
		// шапка
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, Контрагент");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		
		// ТЧ
		СтрокаРеквизитовОбъекта = ("Номенклатура, Количество, Цена, Сумма, СтавкаНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Запасы", СтрокаРеквизитовОбъекта);
		СтрокаРеквизитовОбъекта = ("Номенклатура, Количество, Цена, Сумма, СтавкаНДС");
		СтруктураКлючевыхРеквизитов.Вставить("Расходы", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.АктВыполненныхРабот" Тогда
		// шапка
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, Контрагент");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		
		// ТЧ
		СтрокаРеквизитовОбъекта = ("Номенклатура, Количество, Цена, Сумма, СтавкаНДС");
		СтруктураКлючевыхРеквизитов.Вставить("РаботыИУслуги", СтрокаРеквизитовОбъекта);
		
	ИначеЕсли ИмяОбъекта = "Документ.ПлатежноеПоручение" Тогда
		
		СтрокаРеквизитовОбъекта = ("Дата, Номер, Организация, БанковскийСчет, Контрагент, СчетКонтрагента, СуммаДокумента");
		СтруктураКлючевыхРеквизитов.Вставить("Шапка", СтрокаРеквизитовОбъекта);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Получение текстовых сообщений

// Определяет текст сообщения о необходимости настройки системы в зависимости от вида операции.
//
// Параметры:
//  ВидОперации    - строка - признак выполняемой операции;
//  ТекстСообщения - строка - текст сообщения.
//
Процедура ТекстСообщенияОНеобходимостиНастройкиСистемы(ВидОперации, ТекстСообщения) Экспорт
	
	Если ВРег(ВидОперации) = "РАБОТАСЭД" Тогда
		ТекстСообщения = НСтр("ru = 'Для работы с электронными документами необходимо
			|в настройках системы включить использование обмена электронными документами.'");
	ИначеЕсли ВРег(ВидОперации) = "ПОДПИСАНИЕЭД" Тогда
		ТекстСообщения = НСтр("ru = 'Для возможности подписания ЭД необходимо
			|в настройках системы включить опцию использования электронных цифровых подписей.'");
	ИначеЕсли ВРег(ВидОперации) = "НАСТРОЙКАКРИПТОГРАФИИ" Тогда
		ТекстСообщения = НСтр("ru = 'Для возможности настройки криптографии необходимо 
			|в настройках системы включить опцию использования электронных цифровых подписей.'");
	ИначеЕсли ВРег(ВидОперации) = "РАБОТАСБАНКАМИ" Тогда
			ТекстСообщения = НСтр("ru = 'Для возможности обмена ЭД с банками необходимо 
			|в настройках программы включить опцию использования прямого обмена с банками.'");
	Иначе
		ТекстСообщения = НСтр("ru='Операция не может быть выполнена. Не выполнены необходимые настройки программы.'");
	КонецЕсли;
	
КонецПроцедуры

// Переопределяет выводимое сообщение об ошибке
// КодОшибки - строка
// ТекстОшибки - строка
Процедура ИзменитьСообщениеОбОшибке(КодОшибки, ТекстОшибки) Экспорт
	
	Если КодОшибки = "100" ИЛИ КодОшибки = "110" Тогда
		ТекстОшибки = "Проверьте общие настройки криптографии."
	КонецЕсли;
	
КонецПроцедуры

// Переопределяет сообщение о нехватке прав доступа
//
// Параметры:
//  ТекстСообщения - строка сообщения
//
Процедура ПодготовитьТекстСообщенияОНарушенииПравДоступа(ТекстСообщения) Экспорт
	
	// При необходимости можно переопределить или дополнить текст сообщения
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Получение данных

// Разбирает из переданной строки фамилию, имя и отчество.
//
// Параметры
//  ПолноеНаименование - строка с наименованием;
//  Фамилия - строка с фамилией;
//  Имя - строка с именем;
//  Отчество - строка с отчеством.
//
Процедура РазобратьНаименованиеФизЛица(ПолноеНаименование, Фамилия = " ", Имя = " ", Отчество = " ") Экспорт
	
	ФизическиеЛицаКлиентСервер.ФамилияИнициалыФизЛица(ПолноеНаименование, Фамилия, Имя, Отчество);
	
КонецПроцедуры

// Находит ссылку на объект ИБ по типу, ИД и дополнительным реквизитам
// 
// Параметры:
//  ТипОбъекта - Строка, идентификатор типа объекта, который необходимо найти,
//  ИДОбъекта - Строка, идентификатор объекта заданного типа,
//  ДополнительныеРеквизиты - Структура, набор дополнительных полей объекта для поиска.
//
Функция НайтиСсылкуНаОбъект(ТипОбъекта, ИдОбъекта = "", ДополнительныеРеквизиты = Неопределено, ИДЭД = Неопределено) Экспорт
	
	Параметр = "";
	Результат = Неопределено;
	
	Если ТипОбъекта = "Валюты" 
		ИЛИ ТипОбъекта = "Банки" Тогда
		Результат = НайтиСсылкуНаОбъектПоРеквизиту(ТипОбъекта, "Код", ИдОбъекта);
		
	ИначеЕсли ТипОбъекта = "ЕдиницыИзмерения" Тогда
		Результат = НайтиСсылкуНаОбъектПоРеквизиту("КлассификаторЕдиницИзмерения", "Код", ИдОбъекта);
		
	ИначеЕсли (ТипОбъекта = "Контрагенты" 
		ИЛИ ТипОбъекта = "Организации") 
		И ЗначениеЗаполнено(ДополнительныеРеквизиты) Тогда
		
		ИНН = ""; 
		КПП = "";
		ДополнительныеРеквизиты.Свойство("ИНН", ИНН);
		ДополнительныеРеквизиты.Свойство("КПП", КПП);
		
		Если ЗначениеЗаполнено(ИНН) Тогда // по ИНН+КПП
			
			Результат = ОбменСКонтрагентамиПереопределяемый.СсылкаНаОбъектПоИННКПП(ТипОбъекта, ИНН, КПП); 
			
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Результат) 
			И ДополнительныеРеквизиты.Свойство("Наименование", Параметр) Тогда // по Наименованию
			
			Результат = НайтиСсылкуНаОбъектПоРеквизиту(ТипОбъекта, "Наименование", Параметр); 
			
		КонецЕсли;
		
	ИначеЕсли ТипОбъекта = "НоменклатураПоставщиков" И ЗначениеЗаполнено(ДополнительныеРеквизиты) Тогда
		
		Контрагент = "";
		ДополнительныеРеквизиты.Свойство("Владелец", Контрагент);
		
		ПараметрПоиска = "";
		Если ДополнительныеРеквизиты.Свойство("Идентификатор", ПараметрПоиска) И ЗначениеЗаполнено(ПараметрПоиска) Тогда
			Результат = УправлениеНебольшойФирмойЭлектронныеДокументыСервер.НайтиСсылкуНаНоменклатуруПоставщикаПоИдентификатору(ПараметрПоиска, Контрагент, "НоменклатураПоставщика");
		ИначеЕсли ДополнительныеРеквизиты.Свойство("Ид", ПараметрПоиска) И ЗначениеЗаполнено(ПараметрПоиска) Тогда
			Результат = УправлениеНебольшойФирмойЭлектронныеДокументыСервер.НайтиСсылкуНаНоменклатуруПоставщикаПоИдентификатору(ПараметрПоиска, Контрагент, "НоменклатураПоставщика");
		КонецЕсли;
		
	ИначеЕсли ТипОбъекта = "ХарактеристикаНоменклатуры" 
		И ЗначениеЗаполнено(ДополнительныеРеквизиты)
		И ДополнительныеРеквизиты.Свойство("Идентификатор", Параметр) Тогда
		
		Попытка
			ИдентификаторСтрока = Сред(Параметр, Найти(Параметр, "#")-1);
			ХарактеристикаСсылка = Справочники.ХарактеристикиНоменклатуры.ПолучитьСсылку(Новый УникальныйИдентификатор(ИдентификаторСтрока));
			Если ЗначениеЗаполнено(ХарактеристикаСсылка) Тогда
				Результат = ХарактеристикаСсылка;
			КонецЕсли;
		Исключение
		КонецПопытки;
		
	ИначеЕсли ТипОбъекта = "Номенклатура" Тогда
		
		ПараметрПоиска = "";
		Контрагент = "";
		Если ДополнительныеРеквизиты.Свойство("Идентификатор", ПараметрПоиска)
			И ДополнительныеРеквизиты.Свойство("Владелец", Контрагент) Тогда // по Идентификатору
			Результат = УправлениеНебольшойФирмойЭлектронныеДокументыСервер.НайтиСсылкуНаНоменклатуруПоставщикаПоИдентификатору(ПараметрПоиска, Контрагент);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Результат) Тогда
			
			Если ЗначениеЗаполнено(ИдОбъекта) Тогда
				// Если задан Ид, то будем искать по коду
				Результат = НайтиСсылкуНаОбъектПоРеквизиту(ТипОбъекта, "Код", ИдОбъекта);
				
			ИначеЕсли ЗначениеЗаполнено(ДополнительныеРеквизиты) И ДополнительныеРеквизиты.Свойство("Идентификатор", Параметр) Тогда
				
				Попытка
					ИдентификаторСтрока = Лев(Параметр, Найти(Параметр, "#")-1);
					НоменклатураСсылка = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(ИдентификаторСтрока));
					Если ЗначениеЗаполнено(НоменклатураСсылка) Тогда
						Результат = НоменклатураСсылка;
					КонецЕсли;
				Исключение
				КонецПопытки;
				
			ИначеЕсли ЗначениеЗаполнено(ДополнительныеРеквизиты) И ДополнительныеРеквизиты.Свойство("Код", Параметр) Тогда
				
				Результат = НайтиСсылкуНаОбъектПоРеквизиту(ТипОбъекта, "Код", Параметр);
				
			КонецЕсли;
			
		КонецЕсли;
		
	ИначеЕсли ТипОбъекта = "ВидыКонтактнойИнформации" Тогда
		
		Попытка 
			Результат = Справочники.ВидыКонтактнойИнформации[ИдОбъекта];
		Исключение
			Результат = Неопределено;
		КонецПопытки;
		
	ИначеЕсли (ТипОбъекта = "БанковскиеСчетаОрганизаций" Или ТипОбъекта = "БанковскиеСчетаКонтрагентов") И ЗначениеЗаполнено(ДополнительныеРеквизиты)Тогда
		
		Владелец = "";
		Если ДополнительныеРеквизиты.Свойство("Владелец", Владелец) Тогда
			ИмяПрикладногоСправочника = ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ИмяПрикладногоСправочника(ТипОбъекта);
			Результат = НайтиСсылкуНаОбъектПоРеквизиту(ИмяПрикладногоСправочника, "НомерСчета", ИдОбъекта, Владелец);
		КонецЕсли;
		
	ИначеЕсли ТипОбъекта = "СтраныМира" Тогда
		
		Результат = НайтиСсылкуНаОбъектПоРеквизиту("СтраныМира", "Код", ИдОбъекта);
		
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

// Получает печатный номер документа.
//
// Параметры:
//  СсылкаНаОбъект - документссылка - ссылка на документ информационной базы.
//
// Возвращаемое значение:
//  НомерОбъекта - номер документа.
//
Функция ПолучитьПечатныйНомерДокумента(СсылкаНаОбъект) Экспорт
	
	Если ЗначениеЗаполнено(СсылкаНаОбъект) Тогда
	
		Если СсылкаНаОбъект.Дата < Дата('20110101') Тогда
			
			НомерДокумента = УправлениеНебольшойФирмойСервер.ПолучитьНомерНаПечать(СсылкаНаОбъект.Номер, СсылкаНаОбъект.Организация.Префикс);
			
		Иначе
			
			НомерДокумента = ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(СсылкаНаОбъект.Номер, Истина, Истина);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат НомерДокумента;
	
КонецФункции

// Проверяет, готовность документов ИБ для формирования ЭД, и удаляет из массива не готовые документы
//
// Параметры
//  ДокументыМассив - Массив   - ссылки на документы, которые должны быть проверены перед формированием ЭД.
//
Процедура ПроверитьГотовностьИсточников(ДокументыМассив, ФормаИсточник = Неопределено) Экспорт
	
	ОбщегоНазначенияКлиентСервер.УдалитьВсеВхожденияТипаИзМассива(ДокументыМассив, Тип("СтрокаГруппировкиДинамическогоСписка"));
	
	// На основании счетов-фактур с признаком СчетФактураНеВыставляется ЭД формировать не требуется
	МассивНевыставляемыхСчетовФактур = Новый Массив();
	
	ШаблонСообщения = НСтр("ru = 'Документ ""%1"" не выставляется.'");
	Для Каждого Документ Из МассивНевыставляемыхСчетовФактур Цикл
		Найденный = ДокументыМассив.Найти(Документ);
		Если Найденный <> Неопределено Тогда
			ДокументыМассив.Удалить(Найденный);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Строка(Документ)), 
				Документ);
		КонецЕсли;
	КонецЦикла;
	
	// Перед формированием ЭД документы ИБ должны быть проведены
	МассивНепроведенныхДокументов = ОбщегоНазначенияВызовСервера.ПроверитьПроведенностьДокументов(ДокументыМассив);
	КоличествоНепроведенныхДокументов = МассивНепроведенныхДокументов.Количество();
	
	Если КоличествоНепроведенныхДокументов = 0 Тогда
		Возврат;
	Иначе
		Если КоличествоНепроведенныхДокументов = 1 Тогда
			Текст = НСтр("ru = 'Перед формированием ЭД документ необходимо провести.'");
		Иначе
			Текст = НСтр("ru = 'Перед формированием ЭД документы необходимо провести.'");
		КонецЕсли;
	КонецЕсли;
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст);
	
	ШаблонСообщения = НСтр("ru = 'Документ %1 не проведен.'");
	Для Каждого НепроведенныйДокумент Из МассивНепроведенныхДокументов Цикл
		Найденный = ДокументыМассив.Найти(НепроведенныйДокумент.Ссылка);
		Если Найденный <> Неопределено Тогда
			ДокументыМассив.Удалить(Найденный);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Строка(НепроведенныйДокумент.Ссылка)), 
																		НепроведенныйДокумент.Ссылка);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Получает данные о физическом (юридическом) лице по ссылке.
//
// Параметры:
//  ЮрФизЛицо - Ссылка на элемент справочника, по которому надо получить данные.
//
Функция ПолучитьДанныеЮрФизЛица(ЮрФизЛицо, ДатаСведений = Неопределено, БанковскийСчет = Неопределено) Экспорт
	
	Дата = ?(ДатаСведений = Неопределено, ТекущаяДатаСеанса(), ДатаСведений);
	Сведения = УправлениеНебольшойФирмойСервер.СведенияОЮрФизЛице(ЮрФизЛицо, Дата,, БанковскийСчет);
	
	Если ТипЗнч(ЮрФизЛицо) = Тип("СправочникСсылка.Организации") Тогда
		ТипЮрФизЛица = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЮрФизЛицо, "ЮридическоеФизическоеЛицо");
	Иначе
		ВидКонтрагента = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЮрФизЛицо, "ВидКонтрагента");
		Если ВидКонтрагента = Перечисления.ВидыКонтрагентов.ИндивидуальныйПредприниматель
			ИЛИ ВидКонтрагента = Перечисления.ВидыКонтрагентов.ФизическоеЛицо Тогда
			ТипЮрФизЛица = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
		Иначе
			ТипЮрФизЛица = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЮрФизЛица = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо Тогда
		
		Фамилия		= "";
		Имя			= "";
		Отчество	= "";
		
		ФИО = Сведения.ПолноеНаименование;
		Если Не ЗначениеЗаполнено(ФИО) Тогда
			ФИО = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЮрФизЛицо, "Наименование");
		КонецЕсли;
		
		Если ВРЕГ(Лев(ФИО,2))="ИП" Тогда
			ФИО = Прав(ФИО, СтрДлина(ФИО)-2);
		ИначеЕсли ВРЕГ(Лев(ФИО, СтрДлина("Индивидуальный предприниматель")))="ИНДИВИДУАЛЬНЫЙ ПРЕДПРИНИМАТЕЛЬ" Тогда
			ФИО = Прав(ФИО, СтрДлина(ФИО)-СтрДлина("Индивидуальный предприниматель"));
		КонецЕсли;
		ФИО = СтрЗаменить(ФИО, """","");
		ФИО = СтрЗаменить(ФИО, "'","");
		ФИО = СокрЛП(ФИО);
		
		Сведения.ПолноеНаименование = ФИО;
		
		ФизическиеЛицаКлиентСервер.ФамилияИнициалыФизЛица(Сведения.ПолноеНаименование, Фамилия, Имя, Отчество);
		
		Сведения.Вставить("Фамилия",	Фамилия);
		Сведения.Вставить("Имя",		Имя);
		Сведения.Вставить("Отчество",	Отчество);
		
	КонецЕсли;
	
	Сведения.Вставить("Ссылка",    ЮрФизЛицо);
	Сведения.Вставить("ЮрФизЛицо", ТипЮрФизЛица);
	Сведения.Вставить("ОфициальноеНаименование", Сведения.ПолноеНаименование);
	
	Возврат Сведения
	
КонецФункции

// Возвращает текстовое описание организации.
//
// Параметры:
//  СведенияОКонтрагенте - Структура, сведения об организации, по которой надо составить описание.
//  Список - Строка, список запрашиваемых параметров организации.
//  СПрефиксом - Булево, признак вывода префикса параметра организации.
//
Функция ОписаниеОрганизации(СведенияОКонтрагенте, Список = "", СПрефиксом = Истина) Экспорт
	
	Возврат УправлениеНебольшойФирмойСервер.ОписаниеОрганизации(СведенияОКонтрагенте, Список, СПрефиксом);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с правами

// Проверяет наличие прав обрабатывать электронный документы.
//
// Возвращаемое значение:
//  Булево - истина или ложь, в зависимости от установленных прав.
//
Функция ЕстьПравоОбработкиЭД() Экспорт
	
	Результат = Пользователи.РолиДоступны("ВыполнениеОбменаЭД, ПолныеПрава");
	
	Возврат Результат;
	
КонецФункции

// Проверяет наличие прав читать электронный документы.
//
// Возвращаемое значение:
//  Булево - истина или ложь, в зависимости от установленных прав.
//
Функция ЕстьПравоЧтенияЭД() Экспорт
	
	Результат = Пользователи.РолиДоступны("ВыполнениеОбменаЭД, ЧтениеЭД, ПолныеПрава");
	
	Возврат Результат;
	
КонецФункции

// Проверяет наличие прав на открытие журнала регистрации.
//
// Возвращаемое значение:
//  Булево - истина или ложь, в зависимости от установленных прав.
//
Функция ЕстьПравоОткрытияЖурналаРегистрации() Экспорт
	
	Результат = Пользователи.ЭтоПолноправныйПользователь();
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Находит ссылку на справочник по переданному реквизиту.
//
// Параметры:
//  ИмяСправочника - Строка, имя справочника, объект которого надо найти,
//  ИмяРеквизита - Строка, имя реквизита, по которому будет проведен поиск,
//  ЗначРеквизита - произвольное значение, значение реквизита, по которому будет проведен поиск,
//  Владелец - Ссылка на владельца для поиска в иерархическом справочнике.
//
Функция НайтиСсылкуНаОбъектПоРеквизиту(ИмяСправочника, ИмяРеквизита, ЗначРеквизита, Владелец = Неопределено) Экспорт
	
	Результат = Неопределено;
	
	ОбъектМетаданных = Метаданные.Справочники[ИмяСправочника];
	Если НЕ ОбщегоНазначения.ЭтоСтандартныйРеквизит(ОбъектМетаданных.СтандартныеРеквизиты, ИмяРеквизита)
		И НЕ ОбъектМетаданных.Реквизиты.Найти(ИмяРеквизита) <> Неопределено Тогда
		
		Возврат Результат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ИскСправочник.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник." + ИмяСправочника + " КАК ИскСправочник
	|ГДЕ
	|	ИскСправочник." + ИмяРеквизита + " = &ЗначРеквизита";
	
	Если ЗначениеЗаполнено(Владелец) Тогда
		Запрос.Текст = Запрос.Текст + " И ИскСправочник.Владелец = &Владелец";
		Запрос.УстановитьПараметр("Владелец", Владелец);
	КонецЕсли;
	Запрос.УстановитьПараметр("ЗначРеквизита", ЗначРеквизита);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
