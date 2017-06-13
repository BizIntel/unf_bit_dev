﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Обновление списка заказов.
	МассивЗаказов = Новый Массив;
	Список.Параметры.УстановитьЗначениеПараметра("СписокЗаказов", МассивЗаказов);
	
	// Обновление списка документов отгрузки.
	СписокДокументовОтгрузки = Новый СписокЗначений;
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(ДокументыОтгрузки, "Ссылка", СписокДокументовОтгрузки, Истина, ВидСравненияКомпоновкиДанных.ВСписке);
	
	// Вызов из панели функций.
	Если Параметры.Свойство("Ответственный") Тогда
		ОтборОтветственный = Параметры.Ответственный;
	КонецЕсли;
	
	Список.Параметры.УстановитьЗначениеПараметра("АкутальнаяДатаСеанса", НачалоДня(ТекущаяДатаСеанса()));
	Список.Параметры.УстановитьЗначениеПараметра("АкутальнаяДатаВремяСеанса", ТекущаяДатаСеанса());
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ГруппаВажныеКомандыЗаказНаряд", "Видимость", Ложь);
	
	// Инициализация электронной почты.
	Если Пользователи.ЭтоПолноправныйПользователь()
	ИЛИ (РольДоступна("ВыводНаПринтерФайлБуферОбмена")
		И РаботаСПочтовымиСообщениями.ПроверитьСистемнаяУчетнаяЗаписьДоступна())Тогда
		СистемнаяУчетнаяЗаписьЭлектроннойПочты = РаботаСПочтовымиСообщениями.СистемнаяУчетнаяЗапись();
	Иначе
		Элементы.КИЭлектроннаяПочтаАдрес.Гиперссылка = Ложь;
		Элементы.КИКонтактноеЛицоЭлектроннаяПочтаАдрес.Гиперссылка = Ложь;
	КонецЕсли;
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеОтмененногоЗаказа(
		Список.КомпоновщикНастроек.Настройки.УсловноеОформление
	);
	
	УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	
	// Установим формат для текущей даты: ДФ=Ч:мм
	УправлениеНебольшойФирмойСервер.УстановитьОформлениеКолонкиДата(Список);
	
	// ЭДО
	ПараметрыПриСозданииНаСервере = ОбменСКонтрагентами.ПараметрыПриСозданииНаСервере_ФормаСписка();
	ПараметрыПриСозданииНаСервере.Форма = ЭтотОбъект;
	ПараметрыПриСозданииНаСервере.МестоРазмещенияКоманд = Элементы.ГруппаКомандыЭДО;
	ОбменСКонтрагентами.ПриСозданииНаСервере_ФормаСписка(Отказ, СтандартнаяОбработка, ПараметрыПриСозданииНаСервере);
	// Конец ЭДО
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ГруппаВажныеКомандыЗаказПокупателя);
	
	ОбъектыПечати = Новый Массив;
	ОбъектыПечати.Добавить(Метаданные.Документы.РасходнаяНакладная);
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект, Элементы.КомандыПечати, ОбъектыПечати);
	// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// ЭДО
	ОбменСКонтрагентамиКлиент.ПриОткрытии(ЭтотОбъект);
	// Конец ЭДО
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_РасходнаяНакладная"
	 ИЛИ ИмяСобытия = "Запись_АктВыполненныхРабот"
	 ИЛИ ИмяСобытия = "ОповещениеОбОплатеЗаказа" 
	 ИЛИ ИмяСобытия = "ОповещениеОбИзмененииДолга" Тогда
		ОбновитьСписокЗаказов();
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_РасходнаяНакладная" Тогда
		ОбновитьСписокДокументовОтгрузки();
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_СостоянияЗаказовПокупателей" Тогда
		УстановитьУсловноеОформлениеПоЦветамСостоянийСервер();
	КонецЕсли;
	
	// ЭДО
	ПараметрыОповещенияЭДО = ОбменСКонтрагентамиКлиент.ПараметрыОповещенияЭДО_ФормаСписка();
	ПараметрыОповещенияЭДО.Форма = ЭтотОбъект;
	ПараметрыОповещенияЭДО.ИмяДинамическогоСписка = "Список";
	ОбменСКонтрагентамиКлиент.ОбработкаОповещения_ФормаСписка(ИмяСобытия, Параметр, Источник, ПараметрыОповещенияЭДО);
	// Конец ЭДО
	
КонецПроцедуры // ОбработкаОповещения()

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ОтборОрганизация = Настройки.Получить("ОтборОрганизация");
	ОтборСостояние = Настройки.Получить("ОтборСостояние");
	ОтборКонтрагент = Настройки.Получить("ОтборКонтрагент");
	
	// Исключается вызов из панели функций.
	Если НЕ Параметры.Свойство("Ответственный") Тогда
		ОтборОтветственный = Настройки.Получить("ОтборОтветственный");
	КонецЕсли;
	Настройки.Удалить("ОтборОтветственный");
	
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список, "ОтборОрганизация", ОтборОрганизация, ЗначениеЗаполнено(ОтборОрганизация));
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Ответственный", ОтборОтветственный, ЗначениеЗаполнено(ОтборОтветственный));
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список, "СостояниеЗаказа", ОтборСостояние, ЗначениеЗаполнено(ОтборСостояние));
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Контрагент", ОтборКонтрагент, ЗначениеЗаполнено(ОтборКонтрагент));
	
КонецПроцедуры // ПриЗагрузкеДанныхИзНастроекНаСервере()

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	
	ПодключитьОбработчикОжидания("ОбработатьАктивизациюСтрокиСписка", 0.2, Истина);
	
КонецПроцедуры // СписокПриАктивизацииСтроки()

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Организация", ОтборОрганизация, ЗначениеЗаполнено(ОтборОрганизация));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборОтветственныйПриИзменении(Элемент)
	
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Ответственный", ОтборОтветственный, ЗначениеЗаполнено(ОтборОтветственный));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборСостояниеПриИзменении(Элемент)
	
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список, "СостояниеЗаказа", ОтборСостояние, ЗначениеЗаполнено(ОтборСостояние));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборКонтрагентПриИзменении(Элемент)
	
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список, "Контрагент", ОтборКонтрагент, ЗначениеЗаполнено(ОтборКонтрагент));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьEmailКонтрагенту(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если СписокТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Получатели = Новый Массив;
	Если ЗначениеЗаполнено(ИнформацияКонтрагентЭП) Тогда
		СтруктураПолучателя = Новый Структура;
		СтруктураПолучателя.Вставить("Представление", СписокТекущиеДанные.Контрагент);
		СтруктураПолучателя.Вставить("Адрес", ИнформацияКонтрагентЭП);
		Получатели.Добавить(СтруктураПолучателя);
	КонецЕсли;
	
	ПараметрыОтправки = Новый Структура;
	ПараметрыОтправки.Вставить("Получатель", Получатели);
	
	РаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыОтправки);
	
КонецПроцедуры // ОтправитьEmailКонтрагенту()

&НаКлиенте
Процедура ОтправитьEmailКонтактномуЛицу(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	СписокТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если СписокТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Получатели = Новый Массив;
	Если ЗначениеЗаполнено(ИнформацияКонтактноеЛицоЭП) Тогда
		СтруктураПолучателя = Новый Структура;
		СтруктураПолучателя.Вставить("Представление", СписокТекущиеДанные.КонтактноеЛицо);
		СтруктураПолучателя.Вставить("Адрес", ИнформацияКонтактноеЛицоЭП);
		Получатели.Добавить(СтруктураПолучателя);
	КонецЕсли;
	
	ПараметрыОтправки = Новый Структура;
	ПараметрыОтправки.Вставить("Получатель", Получатели);
	
	РаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(ПараметрыОтправки);
	
КонецПроцедуры // ОтправитьEmailКонтактномуЛицу()

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьОтгрузку(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Команда не может быть выполнена для указанного объекта!'");
		ПоказатьПредупреждение(Неопределено,ТекстПредупреждения);
		Возврат;
		
	КонецЕсли;
	
	МассивЗаказов = Элементы.Список.ВыделенныеСтроки;
	
	Если МассивЗаказов.Количество() = 1 Тогда
		
		ПараметрыОткрытия = Новый Структура("Основание", МассивЗаказов[0]);
		ОткрытьФорму("Документ.РасходнаяНакладная.ФормаОбъекта", ПараметрыОткрытия);
		
	Иначе
		
		СтруктураДанных = ПроверитьКлючевыеРеквизитыЗаказов(МассивЗаказов);
		Если СтруктураДанных.СформироватьНесколькоЗаказов Тогда
			
			ТекстСообщения = НСтр("ru = 'Заказы отличаются данными (%ПредставлениеДанных%) шапки документов! Сформировать несколько расходных накладных?'");
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПредставлениеДанных%", СтруктураДанных.ПредставлениеДанных);
			Ответ = Неопределено;

			ПоказатьВопрос(Новый ОписаниеОповещения("СоздатьОтгрузкуЗавершение", ЭтотОбъект, Новый Структура("МассивЗаказов", МассивЗаказов)), ТекстСообщения, РежимДиалогаВопрос.ДаНет, 0);
            Возврат;
			
		Иначе
			
			СтруктураЗаполнения = Новый Структура();
			СтруктураЗаполнения.Вставить("МассивЗаказовПокупателей", МассивЗаказов);
			ОткрытьФорму("Документ.РасходнаяНакладная.ФормаОбъекта", Новый Структура("Основание", СтруктураЗаполнения));
			
		КонецЕсли;
		
	КонецЕсли;
	
	СоздатьОтгрузкуФрагмент(МассивЗаказов);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СоздатьОтгрузкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    МассивЗаказов = ДополнительныеПараметры.МассивЗаказов;
    
    
    Ответ = Результат;
    Если Ответ = КодВозвратаДиалога.Да Тогда
        
        МассивДокументовПродаж = СформироватьДокументыПродажИЗаписать(МассивЗаказов);
        Текст = НСтр("ru='Создание:'");
        Для каждого СтрокаДокументПродажи Из МассивДокументовПродаж Цикл
            
            ПоказатьОповещениеПользователя(Текст, ПолучитьНавигационнуюСсылку(СтрокаДокументПродажи), СтрокаДокументПродажи, БиблиотекаКартинок.Информация32);
            
        КонецЦикла;
        
    КонецЕсли;
    
    
    СоздатьОтгрузкуФрагмент(МассивЗаказов);

КонецПроцедуры

&НаКлиенте
Процедура СоздатьОтгрузкуФрагмент(Знач МассивЗаказов)
    
    Перем СтрокаЗаказ;
    
    Для каждого СтрокаЗаказ Из МассивЗаказов Цикл
        СписокЗаказов.Добавить(СтрокаЗаказ);
    КонецЦикла;

КонецПроцедуры // СоздатьОтгрузку()

&НаКлиенте
Процедура ОбработатьАктивизациюСтрокиСписка()
	
	ПараметрыИнфПанели = Новый Структура("РеквизитКИ, Контрагент, КонтактноеЛицо", "Контрагент");
	УправлениеНебольшойФирмойКлиент.ИнформационнаяПанельОбработатьАктивизациюСтрокиСписка(ЭтотОбъект, ПараметрыИнфПанели);
	
	Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда
		ОбновитьСписокДокументовОтгрузки();
	КонецЕсли;
	
КонецПроцедуры // ОбработатьАктивизациюСтрокиСписка()

&НаСервереБезКонтекста
Функция ПолучитьСписокСвязанныхДокументов(ДокументЗаказПокупателя)
	
	СписокДокументовОтгрузки = Новый СписокЗначений;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СтруктураПодчиненности.Ссылка КАК ДокСсылка
	|ИЗ
	|	КритерийОтбора.СтруктураПодчиненности(&ДокументЗаказПокупателя) КАК СтруктураПодчиненности
	|ГДЕ
	|	ТИПЗНАЧЕНИЯ(СтруктураПодчиненности.Ссылка) = ТИП(Документ.РасходнаяНакладная)";
	
	Запрос.УстановитьПараметр("ДокументЗаказПокупателя", ДокументЗаказПокупателя);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СписокДокументовОтгрузки.Добавить(Выборка.ДокСсылка);
	КонецЦикла;
	
	Возврат СписокДокументовОтгрузки;
	
КонецФункции // ПолучитьСписокСвязанныхДокументов()

&НаКлиенте
Процедура ОбновитьСписокЗаказов()
	
	МассивЗаказов = СписокЗаказов.ВыгрузитьЗначения();
	Список.Параметры.УстановитьЗначениеПараметра("СписокЗаказов", МассивЗаказов);
	
КонецПроцедуры // ОбновитьСписокЗаказов()

&НаКлиенте
Процедура ОбновитьСписокДокументовОтгрузки()
	
	ДокументЗаказПокупателя = Элементы.Список.ТекущаяСтрока;
	Если ДокументЗаказПокупателя <> Неопределено Тогда
		СписокДокументовОтгрузки = ПолучитьСписокСвязанныхДокументов(ДокументЗаказПокупателя);
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(ДокументыОтгрузки, "Ссылка", СписокДокументовОтгрузки, Истина, ВидСравненияКомпоновкиДанных.ВСписке);
	КонецЕсли;
	
КонецПроцедуры // ОбновитьСписокДокументовОтгрузки()

&НаСервере
Функция ПроверитьКлючевыеРеквизитыЗаказов(МассивЗаказов)
	
	СтруктураДанных = Новый Структура();
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.Организация) КАК КоличествоОрганизация,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.Контрагент) КАК КоличествоКонтрагент,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.Договор) КАК КоличествоДоговор,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.ВидЦен) КАК КоличествоВидЦен,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.ВидСкидкиНаценки) КАК КоличествоВидСкидкиНаценки,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.ВалютаДокумента) КАК КоличествоВалютаДокумента,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.СуммаВключаетНДС) КАК КоличествоСуммаВключаетНДС,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.НДСВключатьВСтоимость) КАК КоличествоНДСВключатьВСтоимость,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.НалогообложениеНДС) КАК КоличествоНалогообложениеНДС
	|ИЗ
	|	Документ.ЗаказПокупателя КАК ЗаказПокупателяШапка
	|ГДЕ
	|	ЗаказПокупателяШапка.Ссылка В(&МассивЗаказов)
	|
	|ИМЕЮЩИЕ
	|	(КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.Организация) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.Контрагент) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.Договор) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.ВидЦен) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.ВидСкидкиНаценки) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.ВалютаДокумента) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.СуммаВключаетНДС) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.НДСВключатьВСтоимость) > 1
	|		ИЛИ КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказПокупателяШапка.НалогообложениеНДС) > 1)";
	
	Запрос.УстановитьПараметр("МассивЗаказов", МассивЗаказов);
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		СтруктураДанных.Вставить("СформироватьНесколькоЗаказов", Ложь);
		СтруктураДанных.Вставить("ПредставлениеДанных", "");
	Иначе
		СтруктураДанных.Вставить("СформироватьНесколькоЗаказов", Истина);
		ПредставлениеДанных = "";
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			Если Выборка.КоличествоОрганизация > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Организация", ", Организация");
			КонецЕсли;
			
			Если Выборка.КоличествоКонтрагент > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Контрагент", ", Контрагент");
			КонецЕсли;
			
			Если Выборка.КоличествоДоговор > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Договор", ", Договор");
			КонецЕсли;
			
			Если Выборка.КоличествоВидЦен > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Вид цен", ", Вид цен");
			КонецЕсли;
			
			Если Выборка.КоличествоВидСкидкиНаценки > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Вид скидки", ", Вид скидки");
			КонецЕсли;
			
			Если Выборка.КоличествоВалютаДокумента > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Валюта", ", Валюта");
			КонецЕсли;
			
			Если Выборка.КоличествоСуммаВключаетНДС > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Сумма вкл. НДС", ", Сумма вкл. НДС");
			КонецЕсли;
			
			Если Выборка.КоличествоНДСВключатьВСтоимость > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "НДС вкл. в стоимость", ", НДС вкл. в стоимость");
			КонецЕсли;
			
			Если Выборка.КоличествоНалогообложениеНДС > 1 Тогда
				ПредставлениеДанных = ПредставлениеДанных + ?(ПустаяСтрока(ПредставлениеДанных), "Налогообложение", ", Налогообложение");
			КонецЕсли;
			
		КонецЦикла;
		
		СтруктураДанных.Вставить("ПредставлениеДанных", ПредставлениеДанных);
		
	КонецЕсли;
	
	Возврат СтруктураДанных;
	
КонецФункции // ПроверитьКлючевыеРеквизитыЗаказов()

&НаСервере
Функция СформироватьДокументыПродажИЗаписать(МассивЗаказов)
	
	МассивДокументовПродаж = Новый Массив();
	Для каждого СтрокаЗНП Из МассивЗаказов Цикл
		
		НовыйДокументПродажи = Документы.РасходнаяНакладная.СоздатьДокумент();
		
		НовыйДокументПродажи.Дата = ТекущаяДатаСеанса();
		НовыйДокументПродажи.Заполнить(СтрокаЗНП);
		
		НовыйДокументПродажи.Записать();
		МассивДокументовПродаж.Добавить(НовыйДокументПродажи.Ссылка);
		
	КонецЦикла;
	
	Возврат МассивДокументовПродаж;
	
КонецФункции // СформироватьДокументыПродажИЗаписать()

&НаСервере
Процедура УстановитьУсловноеОформлениеПоЦветамСостоянийСервер()
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеПоЦветамСостояний(
		Список.КомпоновщикНастроек.Настройки.УсловноеОформление,
		Метаданные.Справочники.СостоянияЗаказовПокупателей.ПолноеИмя()
	);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиБиблиотек

// ЭДО
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуЭДО(Команда)
	
	ЭлектронноеВзаимодействиеСлужебныйКлиент.ВыполнитьПодключаемуюКомандуЭДО(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбработчикОжиданияЭДО()
	
	ОбменСКонтрагентамиКлиент.ОбработчикОжиданияЭДО(ЭтотОбъект);
	
КонецПроцедуры
// Конец ЭДО

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	Если ТекущийЭлемент = Элементы.Список Тогда
		
		УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Элементы.Список);
		
	Иначе
		
		УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Элементы.СписокДокументыОтгрузки);
		
	КонецЕсли;
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти
