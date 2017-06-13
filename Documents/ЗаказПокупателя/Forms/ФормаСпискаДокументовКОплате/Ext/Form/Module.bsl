﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Обновление списка заказов.
	МассивЗаказов = Новый Массив;
	Список.Параметры.УстановитьЗначениеПараметра("СписокЗаказов", МассивЗаказов);
	
	Если Параметры.Свойство("ВидОперацииЗаказНаряд") Тогда
		ЗначениеОтбора = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаряд;
		ЭтотОбъект.АвтоЗаголовок = Ложь;
		ЭтотОбъект.Заголовок = "Заказ-наряды (к оплате)";
	Иначе
		ЗначениеОтбора = Перечисления.ВидыОперацийЗаказПокупателя.ЗаказНаПродажу;
	КонецЕсли;
	
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(Список,"ВидОперации",ЗначениеОтбора);
	
	// Обновление списка документов оплаты.
	СписокДокументовОплаты = Новый СписокЗначений;
	УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(ДокументыОплаты, "Ссылка", СписокДокументовОплаты, Истина, ВидСравненияКомпоновкиДанных.ВСписке);
	
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
	
	СостоянияЗаказов.УстановитьУсловноеОформлениеЗавершенногоЗаказа(
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
	// Конец СтандартныеПодсистемы.Печать
	
КонецПроцедуры

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
	
	Если ИмяСобытия = "ОповещениеОбОплатеЗаказа" Тогда
		ОбновитьСписокДокументовОплаты();
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
	
КонецПроцедуры

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
	
КонецПроцедуры

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
Процедура СоздатьОплату(Команда)
	
	ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		
		ТекстПредупреждения = НСтр("ru = 'Команда не может быть выполнена для указанного объекта!'");
		ПоказатьПредупреждение(Неопределено,ТекстПредупреждения);
		Возврат;
		
	КонецЕсли;
	
	СписокЗаказов.Добавить(ТекущаяСтрока);
	
	СтруктураТипДС = ПолучитьТипДенежныхСредств(ТекущаяСтрока);
	ТипДенежныхСредств = СтруктураТипДС.ТипДенежныхСредств;
	ЗапланироватьОплату = СтруктураТипДС.ЗапланироватьОплату;
	
	ПараметрыОснования = Новый Структура("Основание, УчитыватьОстатки", ТекущаяСтрока, Истина);
	Если ЗапланироватьОплату Тогда
		Если ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Наличные") Тогда
			ОткрытьФорму("Документ.ПоступлениеВКассу.ФормаОбъекта", Новый Структура("Основание", ПараметрыОснования));
		Иначе
			ОткрытьФорму("Документ.ПоступлениеНаСчет.ФормаОбъекта", Новый Структура("Основание", ПараметрыОснования));
		КонецЕсли;
	Иначе
		СписокДокументыОплаты = Новый СписокЗначений();
		СписокДокументыОплаты.Добавить("ПоступлениеВКассу", "Поступление в кассу");
		СписокДокументыОплаты.Добавить("ПоступлениеНаСчет", "Поступление на счет");
		ВыбранныйЗаказ = Неопределено;

		СписокДокументыОплаты.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("СоздатьОплатуЗавершение", ЭтотОбъект, Новый Структура("ПараметрыОснования", ПараметрыОснования)), "Выберете способ оплаты");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СоздатьОплатуЗавершение(Результат, ДополнительныеПараметры) Экспорт
    
    ПараметрыОснования = ДополнительныеПараметры.ПараметрыОснования;
    
    
    ВыбранныйЗаказ = Результат;
    Если ВыбранныйЗаказ <> Неопределено Тогда
        Если ВыбранныйЗаказ.Значение = "ПоступлениеВКассу" Тогда
            ОткрытьФорму("Документ.ПоступлениеВКассу.ФормаОбъекта", Новый Структура("Основание", ПараметрыОснования));
        Иначе
            ОткрытьФорму("Документ.ПоступлениеНаСчет.ФормаОбъекта", Новый Структура("Основание", ПараметрыОснования));
        КонецЕсли;
    КонецЕсли;

КонецПроцедуры // СоздатьОплату()

&НаКлиенте
Процедура ОбработатьАктивизациюСтрокиСписка()
	
	ПараметрыИнфПанели = Новый Структура("РеквизитКИ, Контрагент, КонтактноеЛицо", "Контрагент");
	УправлениеНебольшойФирмойКлиент.ИнформационнаяПанельОбработатьАктивизациюСтрокиСписка(ЭтотОбъект, ПараметрыИнфПанели);
	
	Если Элементы.Список.ТекущаяСтрока <> Неопределено Тогда
		ОбновитьСписокДокументовОплаты();
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
	|	(ТИПЗНАЧЕНИЯ(СтруктураПодчиненности.Ссылка) = ТИП(Документ.ПоступлениеВКассу)
	|			ИЛИ ТИПЗНАЧЕНИЯ(СтруктураПодчиненности.Ссылка) = ТИП(Документ.ПоступлениеНаСчет))";
	
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
Процедура ОбновитьСписокДокументовОплаты()
	
	ДокументЗаказПокупателя = Элементы.Список.ТекущаяСтрока;
	Если ДокументЗаказПокупателя <> Неопределено Тогда
		СписокДокументовОплаты = ПолучитьСписокСвязанныхДокументов(ДокументЗаказПокупателя);
		УправлениеНебольшойФирмойКлиентСервер.УстановитьЭлементОтбораСписка(ДокументыОплаты, "Ссылка", СписокДокументовОплаты, Истина, ВидСравненияКомпоновкиДанных.ВСписке);
	КонецЕсли;
	
КонецПроцедуры // ОбновитьСписокДокументовОплаты()

&НаСервере
Функция ПолучитьТипДенежныхСредств(ДокументСсылка)
	
	СтруктураТипДС = Новый Структура;
	СтруктураТипДС.Вставить("ТипДенежныхСредств", ДокументСсылка.ТипДенежныхСредств);
	СтруктураТипДС.Вставить("ЗапланироватьОплату", ДокументСсылка.ЗапланироватьОплату);
	
	Возврат СтруктураТипДС;
	
КонецФункции // ПолучитьТипДенежныхСредств()

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
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

#КонецОбласти
