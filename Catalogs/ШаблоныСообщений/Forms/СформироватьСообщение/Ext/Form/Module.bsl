﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Предмет = Параметры.Предмет;
	ВидСообщения = Параметры.ВидСообщения;
	РежимВыбора = Параметры.РежимВыбора;
	
	Если ВидСообщения = "СообщениеSMS" Тогда
		ПредназначенДляSMS = Истина;
		ПредназначенДляЭлектронныхПисем = Ложь;
		Заголовок = НСтр("ru = 'Шаблоны сообщений SMS'");
	Иначе
		ПредназначенДляSMS = Ложь;
		ПредназначенДляЭлектронныхПисем = Истина;
	КонецЕсли;
	
	Если НЕ ПравоДоступа("Изменение", Метаданные.Справочники.ШаблоныСообщений) Тогда
		ЕстьПравоИзменения = Ложь;
		Элементы.ФормаИзменить.Видимость = Ложь;
		Элементы.ФормаСоздать.Видимость = Ложь;
	Иначе
		ЕстьПравоИзменения = Истина;
	КонецЕсли;
	
	Если РежимВыбора Тогда
		Элементы.ФормаСформироватьИОтправить.Видимость = Ложь;
	КонецЕсли;
	
	ЗаполнитьСписокДоступныхШаблонов();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ПустойСписокШаблонов Тогда
		ПараметрыОтправки = КонструкторПараметровОтправки();
		ПараметрыОтправки.ДополнительныеПараметры.ПреобразовыватьHTMLДляФорматированногоДокумента = Истина;
		Закрыть();
		ОткрытьФормуСообщения(ПараметрыОтправки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПослеЗаписиШаблонаСообщения" Тогда
		СсылкаНаВыбранныйЭлемент = Неопределено;
		Если Элементы.Шаблоны.ТекущиеДанные <> Неопределено Тогда
			СсылкаНаВыбранныйЭлемент = Элементы.Шаблоны.ТекущиеДанные.Ссылка;
		КонецЕсли;
		ЗаполнитьСписокДоступныхШаблонов();
		НайденныеСтроки = Шаблоны.НайтиСтроки(Новый Структура("Ссылка", СсылкаНаВыбранныйЭлемент));
		Если НайденныеСтроки.Количество() > 0 Тогда
			Элементы.Шаблоны.ТекущаяСтрока = НайденныеСтроки[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыШаблоны

&НаКлиенте
Процедура ШаблоныПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
	СоздатьНовыйШаблон();
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныПриАктивизацииСтроки(Элемент)
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		Элементы.ФормаСформироватьИОтправить.Доступность = (Элемент.ТекущиеДанные.Имя <> "<БезШаблона>");
		Если Элемент.ТекущиеДанные.ТипТекстаПисьма = ПредопределенноеЗначение("Перечисление.СпособыРедактированияЭлектронныхПисем.HTML") Тогда
			Элементы.СтраницыПредпросмотра.ТекущаяСтраница = Элементы.СтраницаФорматированныйДокумент;
			УстановитьHTMLВФорматированныйДокумент(Элемент.ТекущиеДанные.ТекстШаблона, Элемент.ТекущиеДанные.Ссылка);
		Иначе
			Элементы.СтраницыПредпросмотра.ТекущаяСтраница = Элементы.СтраницаОбычныйТекст;
			ПредпросмотрОбычныйТекст.УстановитьТекст(Элемент.ТекущиеДанные.ТекстШаблона);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы = Новый Структура("Ключ", Элемент.ТекущиеДанные.Ссылка);
		ОткрытьФорму("Справочник.ШаблоныСообщений.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Если РежимВыбора Тогда
		ТекущиеДанные = Шаблоны.НайтиПоИдентификатору(ВыбраннаяСтрока);
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
	
		ПараметрыОтправки = КонструкторПараметровОтправки(ТекущиеДанные.Ссылка);
		ПараметрыОтправки.ДополнительныеПараметры.ПреобразовыватьHTMLДляФорматированногоДокумента = Истина;
		Сообщение = СформироватьСообщение(ПараметрыОтправки, ВидСообщения);
		Закрыть(Сообщение);
	Иначе
		СформироватьСообщениеПоВыбранномШаблону();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьСообщениеПоВыбранномШаблону();
КонецПроцедуры

&НаКлиенте
Процедура СформироватьИОтправить(Команда)
	
	ТекущиеДанные = Шаблоны.НайтиПоИдентификатору(Элементы.Шаблоны.ТекущаяСтрока);
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОтправки = КонструкторПараметровОтправки(ТекущиеДанные.Ссылка);
	Если ТекущиеДанные.ЕстьПроизвольныеПараметры Тогда
		ВводПараметров(ТекущиеДанные.Ссылка, ПараметрыОтправки, Истина);
	Иначе
		ОтравитьСообщение(ПараметрыОтправки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Создать(Команда)
	СоздатьНовыйШаблон();
КонецПроцедуры

&НаКлиенте
Процедура ВводПараметров(Шаблон, ПараметрыОтправки, ОтправлятьСразу)
	
	ПараметрыДляЗаполнения = Новый Структура("Шаблон, Предмет", Шаблон, Предмет);
	ДополнительныеПараметры = Новый Структура("ПараметрыОтправки, ОтправлятьСразу", ПараметрыОтправки, ОтправлятьСразу);
	Оповещение = Новый ОписаниеОповещения("ПослеВводаПараметров", ЭтотОбъект, ДополнительныеПараметры);
	ОткрытьФорму("Справочник.ШаблоныСообщений.Форма.ЗаполнитьПроизвольныеПараметры", ПараметрыДляЗаполнения,,,,, Оповещение);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СформироватьСообщениеПоВыбранномШаблону()
	
	ТекущиеДанные = Шаблоны.НайтиПоИдентификатору(Элементы.Шаблоны.ТекущаяСтрока);
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОтправки = КонструкторПараметровОтправки(ТекущиеДанные.Ссылка);
	ПараметрыОтправки.ДополнительныеПараметры.ПреобразовыватьHTMLДляФорматированногоДокумента = Истина;
	Если РежимВыбора Тогда
		Сообщение = СформироватьСообщение(ПараметрыОтправки, ВидСообщения);
		Закрыть(Сообщение);
	Иначе
		Если ТекущиеДанные.ЕстьПроизвольныеПараметры Тогда
			ВводПараметров(ТекущиеДанные.Ссылка, ПараметрыОтправки, Ложь);
		Иначе
			Закрыть();
			ОткрытьФормуСообщения(ПараметрыОтправки);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеВводаПараметров(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено И Результат <> КодВозвратаДиалога.Отмена Тогда
		Если ДополнительныеПараметры.ОтправлятьСразу Тогда
			ОтравитьСообщение(ДополнительныеПараметры.ПараметрыОтправки);
		Иначе
			Закрыть();
			ДополнительныеПараметры.ПараметрыОтправки.ДополнительныеПараметры.ПроизвольныеПараметры = Результат;
			ОткрытьФормуСообщения(ДополнительныеПараметры.ПараметрыОтправки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтравитьСообщение(Знач ПараметрыОтправкиСообщения)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтравитьСообщениеПроверкаУчетнойЗаписиВыполнена", ЭтотОбъект, ПараметрыОтправкиСообщения);
		МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
		МодульРаботаСПочтовымиСообщениямиКлиент.ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочты(ОписаниеОповещения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтравитьСообщениеПроверкаУчетнойЗаписиВыполнена(Результат, ПараметрыОтправки) Экспорт
	
	Сообщение = СформироватьСообщениеИОтправить(ПараметрыОтправки);
	Если Сообщение.Отправлено Тогда;
		Закрыть();
	Иначе
		ПараметрыОтправки.ДополнительныеПараметры.ПреобразовыватьHTMLДляФорматированногоДокумента = Истина;
		Оповещение = Новый ОписаниеОповещения("ПослеВопросаОбОткрытиеФормыСообщения", ЭтотОбъект, ПараметрыОтправки);
		ОписаниеОшибки = Сообщение.ОписаниеОшибки + Символы.ПС + НСтр("ru = 'Открыть форму отправки сообщения?'");
		ПоказатьВопрос(Оповещение, ОписаниеОшибки, РежимДиалогаВопрос.ДаНет);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СформироватьСообщение(ПараметрыОтправки, ВидСообщения)
	
	Сообщение = ШаблоныСообщений.СформироватьСообщение(ПараметрыОтправки.Шаблон, ПараметрыОтправки.Предмет, ПараметрыОтправки.УникальныйИдентификатор, ПараметрыОтправки.ДополнительныеПараметры);
	Если ВидСообщения = "Письмо" Тогда
		Возврат ПреобразоватьПараметрыПисьма(Сообщение);
	Иначе
		Сообщение.Вложения = Неопределено;
	КонецЕсли;
	
	Возврат Сообщение;
	
КонецФункции

&НаСервере
Функция СформироватьСообщениеИОтправить(ПараметрыОтправки)
	
	Возврат ШаблоныСообщенийСлужебный.СформироватьСообщениеИОтправить(ПараметрыОтправки);
	
КонецФункции

&НаКлиенте
Процедура ОткрытьФормуСообщения(Знач ПараметрыОтправки)
	
	Результат = СформироватьСообщение(ПараметрыОтправки, ВидСообщения);
	
	Если ВидСообщения = "СообщениеSMS" Тогда
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОтправкаSMS") Тогда 
			МодульОтправкаSMSКлиент= ОбщегоНазначенияКлиент.ОбщийМодуль("ОтправкаSMSКлиент");
			ДополнительныеПараметры = Новый Структура("ИсточникКонтактнойИнформации, ПеревестиВТранслит");
			ДополнительныеПараметры.ИсточникКонтактнойИнформации = Предмет;
			ДополнительныеПараметры.ПеревестиВТранслит = Результат.ДополнительныеПараметры.ПеревестиВТранслит;
			МодульОтправкаSMSКлиент.ОтправитьSMS(Результат.Получатель.ВыгрузитьЗначения(), Результат.Текст, ДополнительныеПараметры);
		КонецЕсли;
	Иначе
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
			// УНФ
			Результат.Вставить("ПредметСообщения", ПараметрыОтправки.Предмет);
			Результат.Вставить("ШаблонСообщения", ПараметрыОтправки.Шаблон);
			Результат.Вставить("ИмяФормыОбъектаПечати", ВладелецФормы.ИмяФормы);
			// УНФ
			МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
			МодульРаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(Результат);
		КонецЕсли;
	КонецЕсли;
	
	Если Результат.Свойство("СообщенияПользователю")
		И Результат.СообщенияПользователю.Количество() > 0 Тогда
			Для каждого СообщенияПользователю Из Результат.СообщенияПользователю Цикл
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщенияПользователю.Текст,
					СообщенияПользователю.КлючДанных, СообщенияПользователю.Поле, СообщенияПользователю.ПутьКДанным);
			КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция КонструкторПараметровОтправки(Шаблон = Неопределено)
	
	ПараметрыОтправки = Новый Структура();
	ПараметрыОтправки.Вставить("Шаблон", Шаблон);
	ПараметрыОтправки.Вставить("Предмет", Предмет);
	ПараметрыОтправки.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	ПараметрыОтправки.Вставить("ДополнительныеПараметры", Новый Структура);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ПреобразовыватьHTMLДляФорматированногоДокумента", Ложь);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ВидСообщения", ВидСообщения);
	ПараметрыОтправки.ДополнительныеПараметры.Вставить("ПроизвольныеПараметры", Новый Соответствие);
	
	Возврат ПараметрыОтправки;
	
КонецФункции

&НаКлиенте
Процедура ПослеВопросаОбОткрытиеФормыСообщения(Результат, ПараметрыОтправки) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		ОткрытьФормуСообщения(ПараметрыОтправки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовыйШаблон()
	
	ПараметрыФормы = Новый Структура("ВидСообщения, ПолноеИмяТипаОснования, ТолькоДляАвтора", ВидСообщения, ПолноеИмяТипаОснования, Истина);
	Оповещение = Новый ОписаниеОповещения("ОбновитьОкно", ЭтотОбъект);
	ОткрытьФорму("Справочник.ШаблоныСообщений.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект,,,, )
	
КонецПроцедуры

Процедура ОбновитьОкно(Результат, ДополнительныеПараметры)
	ЗаполнитьСписокДоступныхШаблонов();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДоступныхШаблонов()
	
	Шаблоны.Очистить();
	ТипШаблона = ?(ПредназначенДляSMS, "SMS", "Письмо");
	Запрос = ШаблоныСообщенийСлужебный.ПодготовитьЗапросДляПолученияСпискаШаблонов(ТипШаблона, Предмет);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
		
	Пока РезультатЗапроса.Следующий() Цикл
		НоваяСтрока = Шаблоны.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, РезультатЗапроса);
		
		Если РезультатЗапроса.ШаблонПоВнешнейОбработке
			И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
				МодульДополнительныеОтчетыИОбработки = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработки");
				ВнешнийОбъект = МодульДополнительныеОтчетыИОбработки.ОбъектВнешнейОбработки(РезультатЗапроса.ВнешняяОбработка);
				ПараметрыШаблона = ВнешнийОбъект.ПараметрыШаблона();
				
				Если ПараметрыШаблона.Количество() > 1 Тогда
					ЕстьПроизвольныеПараметры = Истина;
				Иначе
					ЕстьПроизвольныеПараметры = Ложь;
				КонецЕсли;
		Иначе
			ПроизвольныеПараметры = РезультатЗапроса.ЕстьПроизвольныеПараметры.Выгрузить();
			ЕстьПроизвольныеПараметры = ПроизвольныеПараметры.Количество() > 0;
		КонецЕсли;
		
		НоваяСтрока.ЕстьПроизвольныеПараметры = ЕстьПроизвольныеПараметры;
	КонецЦикла;
	
	Если Шаблоны.Количество() = 0 Тогда
		ПустойСписокШаблонов = Истина;
	КонецЕсли;
	
	Шаблоны.Сортировать("Представление");
	
	Если НЕ РежимВыбора Тогда
		ПерваяСтрока = Шаблоны.Вставить(0);
		ПерваяСтрока.Имя = "<БезШаблона>";
		ПерваяСтрока.Представление = НСтр("ru = '<Без шаблона>'");
	КонецЕсли;
	
	Если Шаблоны.Количество() = 0 Тогда
		Элементы.ФормаСоздать.ТолькоВоВсехДействиях = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьHTMLВФорматированныйДокумент(ТекстШаблонаПисьмаHTML, СсылкаНаТекущийОбъект);
	
	ПараметрШаблона = Новый Структура("Шаблон, УникальныйИдентификатор");
	ПараметрШаблона.Шаблон = СсылкаНаТекущийОбъект;
	ПараметрШаблона.УникальныйИдентификатор = УникальныйИдентификатор;
	Сообщение = ШаблоныСообщенийСлужебный.КонструкторСообщения();
	Сообщение.Текст = ТекстШаблонаПисьмаHTML;
	ШаблоныСообщенийСлужебный.ОбработатьHTMLДляФорматированногоДокумента(ПараметрШаблона, Сообщение, Истина);
	СтруктураВложений = Новый Структура();
	Для каждого ВложениеВHTML Из Сообщение.Вложения Цикл
		Изображение = Новый Картинка(ПолучитьИзВременногоХранилища(ВложениеВHTML.АдресВоВременномХранилище));
		СтруктураВложений.Вставить(ВложениеВHTML.Представление, Изображение);
	КонецЦикла;
	ПредпросмотрФорматированныйДокумент.УстановитьHTML(Сообщение.Текст, СтруктураВложений);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПреобразоватьПараметрыПисьма(Сообщение)
	
	ПараметрыПисьма = Новый Структура();
	ПараметрыПисьма.Вставить("Отправитель");
	ПараметрыПисьма.Вставить("Тема", Сообщение.Тема);
	ПараметрыПисьма.Вставить("Текст", Сообщение.Текст);
	ПараметрыПисьма.Вставить("СообщенияПользователю", Сообщение.СообщенияПользователю);
	ПараметрыПисьма.Вставить("УдалятьФайлыПослеОтправки", Ложь);
	
	Если Сообщение.Получатель = Неопределено ИЛИ Сообщение.Получатель.Количество() = 0 Тогда
		ПараметрыПисьма.Вставить("Получатель", "");
	Иначе
		ПараметрыПисьма.Вставить("Получатель", Сообщение.Получатель);
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Взаимодействия")
		И ПолучитьФункциональнуюОпцию("ИспользоватьПочтовыйКлиент") Тогда
		Если ПолучитьФункциональнуюОпцию("ОтправлятьПисьмаВФорматеHTML") Тогда
			СтруктураВложений = Новый Структура();
			
			Индекс = Сообщение.Вложения.Количество() - 1;
			Пока Индекс >= 0 Цикл
				Вложение = Сообщение.Вложения[Индекс];
				Если ЗначениеЗаполнено(Вложение.Идентификатор) Тогда
					Картинка = Новый Картинка(ПолучитьИзВременногоХранилища(Вложение.АдресВоВременномХранилище));
					СтруктураВложений.Вставить(Вложение.Представление, Картинка);
					Сообщение.Вложения.Удалить(Индекс);
				КонецЕсли;
				Индекс = Индекс - 1;
			КонецЦикла;
			ПараметрыПисьма.Текст = Новый Структура("ТекстHTML, СтруктураВложений", ПараметрыПисьма.Текст, СтруктураВложений);
		Иначе
			Если СтрНачинаетсяС(ПараметрыПисьма.Текст, "<!DOCTYPE html") Тогда
				ВременныйФорматированныйДокумент = Новый ФорматированныйДокумент;
				КартинкиПисьма = Новый Структура;
				ВременныйФорматированныйДокумент.УстановитьHTML(ПараметрыПисьма.Текст, КартинкиПисьма);
				ПараметрыПисьма.Текст = ВременныйФорматированныйДокумент.ПолучитьТекст();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	МассивВложений = Новый Массив;
	Для Каждого ОписаниеВложения Из Сообщение.Вложения Цикл
		ИнформацияОВложении = Новый Структура("Представление, АдресВоВременномХранилище, Кодировка, Идентификатор");
		ЗаполнитьЗначенияСвойств(ИнформацияОВложении, ОписаниеВложения);
		МассивВложений.Добавить(ИнформацияОВложении);
	КонецЦикла;
	ПараметрыПисьма.Вставить("Вложения", МассивВложений);
	
	Возврат ПараметрыПисьма;
	
КонецФункции

#КонецОбласти