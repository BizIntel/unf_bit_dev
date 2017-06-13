﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияЕГАИСПереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если ДополнительныеСвойства.Свойство("ЗагрузкаДанныхИзЕГАИС") Тогда
		ПроверяемыеРеквизиты.Очистить();
	Иначе
		МассивНепроверяемыхРеквизитов = Новый Массив;
		Если ВидДокумента = Перечисления.ВидыДокументовЕГАИС.АктПостановкиНаБалансВТорговомЗале Тогда
			МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоПоСправкеА");
			МассивНепроверяемыхРеквизитов.Добавить("Товары.НомерТТН");
			МассивНепроверяемыхРеквизитов.Добавить("Товары.ДатаТТН");
			МассивНепроверяемыхРеквизитов.Добавить("Товары.ДатаРозлива");
		КонецЕсли;
		
		Если ПричинаПостановкиНаБаланс <> Перечисления.ПричиныПостановкиНаБалансЕГАИС.Пересортица Тогда
			МассивНепроверяемыхРеквизитов.Добавить("АктСписанияЕГАИС");
		КонецЕсли;
		
		ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ТаблицаДвижений = ПолучитьТаблицуДвижений();
	
	РегистрыНакопления.ОстаткиАлкогольнойПродукцииЕГАИС.ЗаписатьТаблицуДвижений(ТаблицаДвижений, Движения, Отказ);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	СтатусОбработки = Перечисления.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.Новый;
	
	ИдентификаторЕГАИС = "";
	ДатаРегистрацииДвижений = '00010101';
	
	Товары.ЗагрузитьКолонку(Новый Массив(Товары.Количество()), "СправкаБ");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьТаблицуДвижений()
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ПустаяДата", '00010101');
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	АктПостановкиНаБалансЕГАИСТовары.Ссылка.Дата КАК Период,
	|	АктПостановкиНаБалансЕГАИСТовары.Ссылка КАК Регистратор,
	|	АктПостановкиНаБалансЕГАИСТовары.НомерСтроки КАК НомерСтроки,
	|	АктПостановкиНаБалансЕГАИСТовары.Ссылка.ОрганизацияЕГАИС КАК ОрганизацияЕГАИС,
	|	АктПостановкиНаБалансЕГАИСТовары.АлкогольнаяПродукция КАК АлкогольнаяПродукция,
	|	АктПостановкиНаБалансЕГАИСТовары.СправкаБ КАК СправкаБ,
	|	АктПостановкиНаБалансЕГАИСТовары.Количество КАК СвободныйОстаток,
	|	0 КАК Количество
	|ИЗ
	|	Документ.АктПостановкиНаБалансЕГАИС.Товары КАК АктПостановкиНаБалансЕГАИСТовары
	|ГДЕ
	|	АктПостановкиНаБалансЕГАИСТовары.Ссылка.СтатусОбработки = ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.ПереданВЕГАИС)
	|	И АктПостановкиНаБалансЕГАИСТовары.Ссылка = &Ссылка
	|	И АктПостановкиНаБалансЕГАИСТовары.Ссылка.ОрганизацияЕГАИС.УчитыватьОстаткиАлкогольнойПродукции
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
	|	АктПостановкиНаБалансЕГАИСТовары.Ссылка.ДатаРегистрацииДвижений,
	|	АктПостановкиНаБалансЕГАИСТовары.Ссылка,
	|	АктПостановкиНаБалансЕГАИСТовары.НомерСтроки,
	|	АктПостановкиНаБалансЕГАИСТовары.Ссылка.ОрганизацияЕГАИС,
	|	АктПостановкиНаБалансЕГАИСТовары.АлкогольнаяПродукция,
	|	АктПостановкиНаБалансЕГАИСТовары.СправкаБ,
	|	0,
	|	АктПостановкиНаБалансЕГАИСТовары.Количество
	|ИЗ
	|	Документ.АктПостановкиНаБалансЕГАИС.Товары КАК АктПостановкиНаБалансЕГАИСТовары
	|ГДЕ
	|	АктПостановкиНаБалансЕГАИСТовары.Ссылка.СтатусОбработки = ЗНАЧЕНИЕ(Перечисление.СтатусыОбработкиАктаПостановкиНаБалансЕГАИС.ПереданВЕГАИС)
	|	И АктПостановкиНаБалансЕГАИСТовары.Ссылка = &Ссылка
	|	И АктПостановкиНаБалансЕГАИСТовары.Ссылка.ОрганизацияЕГАИС.УчитыватьОстаткиАлкогольнойПродукции
	|	И АктПостановкиНаБалансЕГАИСТовары.Ссылка.ДатаРегистрацииДвижений <> &ПустаяДата
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецОбласти

#КонецЕсли
