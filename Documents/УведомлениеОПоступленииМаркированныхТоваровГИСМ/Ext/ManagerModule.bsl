﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область Панель1СМаркировка

// Возвращает текст запроса для получения общего количества документов в работе
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаУведомленияОПоступлении() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ КАК СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Документ.УведомлениеОПоступленииМаркированныхТоваровГИСМ КАК УведомлениеОПоступленииМаркированныхТоваровГИСМ
	|ПО
	|	СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.Документ = УведомлениеОПоступленииМаркированныхТоваровГИСМ.Ссылка
	|ГДЕ
	|	УведомлениеОПоступленииМаркированныхТоваровГИСМ.Ссылка ЕСТЬ НЕ NULL
	|	И СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.ДальнейшееДействие <> ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.НеТребуется)
	|	И (УведомлениеОПоступленииМаркированныхТоваровГИСМ.Организация = &Организация
	|		ИЛИ &Организация = НЕОПРЕДЕЛЕНО)
	|	И (УведомлениеОПоступленииМаркированныхТоваровГИСМ.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает текст запроса для получения количества документов для отработки
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаУведомленияОПоступленииОтработайте() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ КАК СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ
	|ЛЕВОЕ СОЕДИНЕНИЕ
	|	Документ.УведомлениеОПоступленииМаркированныхТоваровГИСМ КАК УведомлениеОПоступленииМаркированныхТоваровГИСМ
	|ПО
	|	СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.Документ = УведомлениеОПоступленииМаркированныхТоваровГИСМ.Ссылка
	|ГДЕ
	|	УведомлениеОПоступленииМаркированныхТоваровГИСМ.Ссылка ЕСТЬ НЕ NULL
	|	И СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.ДальнейшееДействие В
	|		(ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПередайтеДанные),
	|		ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ВыполнитеОбмен),
	|		ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПолучитеСчетНаОплату),
	|		ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОплатитеСчет),
	|		ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ПодтвердитеПолучение),
	|		ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ЗакройтеЗаявку),
	|		ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ИсправьтеНекорректныеРеквизиты),
	|		ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.Аннулируйте))
	|	И (СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.Документ.Организация = &Организация
	|		ИЛИ &Организация = НЕОПРЕДЕЛЕНО)
	|	И (СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.Документ.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает текст запроса для получения количества документов, находящихся в состоянии ожидания
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаУведомленияОПоступленииОжидайте() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ КАК СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	Документ.УведомлениеОПоступленииМаркированныхТоваровГИСМ КАК УведомлениеОПоступленииМаркированныхТоваровГИСМ
	|ПО
	|	СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.Документ = УведомлениеОПоступленииМаркированныхТоваровГИСМ.Ссылка
	|ГДЕ
	|	СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.ДальнейшееДействие В
	|	(	ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПередачуДанныхРегламентнымЗаданием),
	|		ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПолучениеКвитанцииОФиксации),
	|		ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеФормированиеСчетаНаОплату),
	|		ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПодтверждениеПолучения),
	|		ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеУтверждениеФНС),
	|		ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПоступлениеТоваров),
	|		ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеУведомлениеОВыпускеКиЗ))
	|	И (УведомлениеОПоступленииМаркированныхТоваровГИСМ.Организация = &Организация
	|		ИЛИ &Организация = НЕОПРЕДЕЛЕНО)
	|	И (УведомлениеОПоступленииМаркированныхТоваровГИСМ.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

// Возвращает текст запроса для получения количества документов для аннулирования
// 
// Возвращаемое значение:
//  Строка - Текст запроса
//
Функция ТекстЗапросаУведомленияОПоступленииАннулируйте() Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КОЛИЧЕСТВО (РАЗЛИЧНЫЕ СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.Документ) КАК КоличествоДокументов
	|ИЗ
	|	РегистрСведений.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ КАК СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ
	|ВНУТРЕННЕЕ СОЕДИНЕНИЕ
	|	Документ.УведомлениеОПоступленииМаркированныхТоваровГИСМ КАК УведомлениеОПоступленииМаркированныхТоваровГИСМ
	|ПО
	|	СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.Документ = УведомлениеОПоступленииМаркированныхТоваровГИСМ.Ссылка
	|ГДЕ
	|	СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.ДальнейшееДействие = ЗНАЧЕНИЕ(Перечисление.ДальнейшиеДействияПоВзаимодействиюГИСМ.Аннулируйте)
	|	И (УведомлениеОПоступленииМаркированныхТоваровГИСМ.Организация = &Организация
	|		ИЛИ &Организация = НЕОПРЕДЕЛЕНО)
	|	И (УведомлениеОПоступленииМаркированныхТоваровГИСМ.Ответственный = &Ответственный
	|		ИЛИ &Ответственный = НЕОПРЕДЕЛЕНО)
	|;
	|/////////////////////////////////////////////////////////////////////////////
	|";
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ДействияПриОбменеГИСМ

// Обновить статус после подготовки к передаче данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  Операция - ПеречислениеСсылка.ОперацииОбменаГИСМ - Операция ГИСМ
// 
// Возвращаемое значение:
//  Перечисления.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ - Новый статус
//
Функция ОбновитьСтатусПослеПодготовкиКПередачеДанных(ДокументСсылка, Операция) Экспорт
	
	НовыйСтатус     = Неопределено;
	ДальнейшееДействие = Неопределено;
	
	ИспользоватьАвтоматическийОбмен = ПолучитьФункциональнуюОпцию("ИспользоватьАвтоматическуюОтправкуПолучениеДанныхГИСМ");
	
	Если Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаАннулирования Тогда
		
		НовыйСтатус = Перечисления.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.КАннулированию;
		Если ИспользоватьАвтоматическийОбмен Тогда
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПередачуДанныхРегламентнымЗаданием;
		Иначе
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ВыполнитеОбмен;
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаПодтверждения Тогда
		
		НовыйСтатус = Перечисления.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.ОбрабатываетсяПоступление;
		Если ИспользоватьАвтоматическийОбмен Тогда
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПередачуДанныхРегламентнымЗаданием;
		Иначе
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ВыполнитеОбмен;
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаЗакрытияЗаявки Тогда
		
		НовыйСтатус = Перечисления.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.КЗакрытию;
		Если ИспользоватьАвтоматическийОбмен Тогда
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПередачуДанныхРегламентнымЗаданием;
		Иначе
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ВыполнитеОбмен;
		КонецЕсли;
		
	КонецЕсли;
	
	Если НовыйСтатус = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйСтатус = РегистрыСведений.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.ОбновитьСтатус(
		ДокументСсылка,
		НовыйСтатус,
		ДальнейшееДействие);
	
	Возврат НовыйСтатус;
	
КонецФункции

// Обновить статус после передачи данных
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  Операция - ПеречислениеСсылка.ОперацииОбменаГИСМ - Операция ГИСМ
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийГИСМ - Статус обработки сообщения
// 
// Возвращаемое значение:
//  Перечисления.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ - Новый статус
//
Функция ОбновитьСтатусПослеПередачиДанных(ДокументСсылка, Операция, СтатусОбработки) Экспорт
	
	ОбновитьСтатус     = Истина;
	НовыйСтатус        = Неопределено;
	ДальнейшееДействие = Неопределено;
	
	Если Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаЗакрытияЗаявки Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
			
			НовыйСтатус = Перечисления.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.КЗакрытиюПередано;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПолучениеКвитанцииОФиксации;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Отклонено
			ИЛИ СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Ошибка Тогда
			
			НовыйСтатус = Перечисления.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.КЗакрытиюОтклоненоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ЗакройтеЗаявку;
			
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаЗакрытияЗаявкиПолучениеКвитанции Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
			
			НовыйСтатус = Перечисления.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.Закрыто;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.НеТребуется;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Отклонено
			ИЛИ СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Ошибка Тогда
			
			НовыйСтатус = Перечисления.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.КЗакрытиюОтклоненоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ЗакройтеЗаявку;
			
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаПодтвержденияПолучениеКвитанции Тогда
		
		ОбновитьСтатус = Ложь;
		НовыйСтатус = ТекущийСтатус(ДокументСсылка);
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаАннулирования Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
			
			НовыйСтатус = Перечисления.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.КАннулированию;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.ОжидайтеПолучениеКвитанцииОФиксации;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Отклонено
			ИЛИ СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Ошибка Тогда
			
			НовыйСтатус = Перечисления.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.КАннулированиюОтклоненоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.Аннулируйте;
			
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаАннулированияПолучениеКвитанции Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
			
			НовыйСтатус = Перечисления.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.Аннулировано;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.НеТребуется;
			
		ИначеЕсли СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Отклонено
			ИЛИ СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Ошибка Тогда
			
			НовыйСтатус = Перечисления.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.КАннулированиюОтклоненоГИСМ;
			ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюГИСМ.Аннулируйте;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если НовыйСтатус = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ОбновитьСтатус Тогда
		НовыйСтатус = РегистрыСведений.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ.ОбновитьСтатус(
			ДокументСсылка,
			НовыйСтатус,
			ДальнейшееДействие);
	КонецЕсли;
	
	Возврат НовыйСтатус;
	
КонецФункции

// Обновить состояние подтверждения
//
// Параметры:
//  ДокументОбъект - ДокументОбъект.УведомлениеОПоступленииМаркированныхТоваровГИСМ - Документ-объект
//  Операция - ПеречислениеСсылка.ОперацииОбменаГИСМ - Операция ГИСМ
//  Сообщение - СправочникСсылка.ГИСМПрисоединенныеФайлы - Полученное сообщение-подтверждение из ГИСМ
//  СтатусОбработки - ПеречислениеСсылка.СтатусыОбработкиСообщенийГИСМ - Статус обработки сообщения
// 
// Возвращаемое значение:
//  Соответствие - Новые состояния подтверждения
//
Функция ОбновитьСостояниеПодтверждения(ДокументОбъект, Операция, Сообщение, СтатусОбработки) Экспорт
	
	Статусы = Новый Соответствие;
	
	Если Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаПодтверждения Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
			НовыйСтатус = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.Передано;
		Иначе
			НовыйСтатус = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.ОтклоненоГИСМ;
		КонецЕсли;
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаПодтвержденияПолучениеКвитанции Тогда
		
		Если СтатусОбработки = Перечисления.СтатусыОбработкиСообщенийГИСМ.Принято Тогда
			НовыйСтатус = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.ПринятоГИСМ;
		Иначе
			НовыйСтатус = Перечисления.СостоянияОтправкиПодтвержденияГИСМ.ОтклоненоГИСМ;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаПодтвержденияПолучениеКвитанции Тогда
		СообщениеПередачаПодтверждения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Сообщение, "СообщениеОснование");
		СообщениеПередачаПодтверждения = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СообщениеПередачаПодтверждения, "СообщениеОснование");
	Иначе
		СообщениеПередачаПодтверждения = Сообщение;
	КонецЕсли;
	
	КонвертSOAP = ИнтеграцияГИСМВызовСервера.КонвертSOAPИзПротокола(СообщениеПередачаПодтверждения);
	
	ТекстСообщенияXML = ИнтеграцияГИСМВызовСервера.ТекстВходящегоСообщенияXML(КонвертSOAP);
	
	ОбъектXDTO = ИнтеграцияГИСМ.ОбъектXDTOПоТекстуСообщенияXML(ТекстСообщенияXML, "query");
	
	Объект = ИнтеграцияГИСМ.ОбъектXDTOВСтруктуру(ОбъектXDTO);
	
	Для Каждого ДанныеЗнака Из Объект.move_commit_signs.details.sign Цикл
		
		НомерКиЗ = ИдентификаторЗнака(ДанныеЗнака, "sign_num");
		СтрокаТЧ = ДокументОбъект.НомераКиЗ.Найти(НомерКиЗ, "НомерКиЗ");
		СтрокаТЧ.СостояниеПодтверждения = НовыйСтатус;
		
	КонецЦикла;
	
	Для Каждого СтрокаТЧ Из ДокументОбъект.НомераКиЗ Цикл
		
		Количество = Статусы.Получить(СтрокаТЧ.СостояниеПодтверждения);
		Если Количество = Неопределено Тогда
			Количество = 0;
		КонецЕсли;
		
		Статусы.Вставить(СтрокаТЧ.СостояниеПодтверждения, Количество + 1);
		
	КонецЦикла;
	
	Возврат Статусы;
	
КонецФункции

// Получить идентификатор знака.
//
// Параметры:
//  СтрокаТЧ - СтрокаТабличнойЧасти - Строка табличной части с номерами КиЗ.
//  НаименованиеИдентификатора	 - Строка - Наименование идентификатора для извлечения из объекта XDTO.
// 
// Возвращаемое значение:
//  Строка - Запрашиваемый идентификатор знака.
//
Функция ИдентификаторЗнака(СтрокаТЧ, НаименованиеИдентификатора)
	
	Если СтрокаТЧ[НаименованиеИдентификатора].Количество() > 0 Тогда
		Возврат СтрокаТЧ[НаименованиеИдентификатора][0];
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции


#КонецОбласти

#Область СообщенияГИСМ

// Сообщение к передаче XML
//
// Параметры:
//  ДокументСсылка - ДокументСсылка - Ссылка на документ
//  Операция - ПеречислениеСсылка.ОперацииОбменаГИСМ - Операция ГИСМ
// 
// Возвращаемое значение:
//  Строка - Текст сообщения XML
//
Функция СообщениеКПередачеXML(ДокументСсылка, Операция) Экспорт
	
	Если Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаПодтверждения Тогда
		Возврат ПодтверждениеПоступленияТоваровПоУведомлениюОбОтгрузкеМаркированныхТоваровXML(ДокументСсылка);
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаПодтвержденияПолучениеКвитанции Тогда
		Возврат ИнтеграцияГИСМВызовСервера.ЗапросКвитанцииОФиксацииПоСсылкеXML(ДокументСсылка, Перечисления.ОперацииОбменаГИСМ.ПередачаПодтверждения);
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаЗакрытияЗаявки Тогда
		Возврат ЗакрытиеУведомленияОПоступленииМаркированныхТоваровXML(ДокументСсылка);
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаЗакрытияЗаявкиПолучениеКвитанции Тогда
		Возврат ИнтеграцияГИСМВызовСервера.ЗапросКвитанцииОФиксацииПоСсылкеXML(ДокументСсылка, Перечисления.ОперацииОбменаГИСМ.ПередачаЗакрытияЗаявки);
		
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаАннулирования Тогда
		Возврат АннулированиеУведомленияОПоступленииМаркированныхТоваровXML(ДокументСсылка);
	ИначеЕсли Операция = Перечисления.ОперацииОбменаГИСМ.ПередачаАннулированияПолучениеКвитанции Тогда
		Возврат ИнтеграцияГИСМВызовСервера.ЗапросКвитанцииОФиксацииПоСсылкеXML(ДокументСсылка, Перечисления.ОперацииОбменаГИСМ.ПередачаАннулирования);
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекущийСтатус(ДокументСсылка)
	
	Статус = Неопределено;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Таблица.Статус КАК Статус
	|ИЗ
	|	РегистрСведений.СтатусыУведомленийОПоступленииМаркированныхТоваровГИСМ КАК Таблица
	|ГДЕ
	|	Таблица.Документ = &ДокументСсылка
	|");
	
	Запрос.УстановитьПараметр("ДокументСсылка", ДокументСсылка);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Статус = Выборка.Статус;
	КонецЕсли;
	
	Возврат Статус;
	
КонецФункции

#Область СообщенияГИСМ

Функция ПодтверждениеПоступленияТоваровПоУведомлениюОбОтгрузкеМаркированныхТоваровXML(ДокументСсылка)
	
	Если ИнтеграцияГИСМ.ИспользоватьВозможностиВерсии("2.41") Тогда
		Возврат ПодтверждениеПоступленияТоваровПоУведомлениюОбОтгрузкеМаркированныхТоваровXML2_41(ДокументСсылка);
	Иначе
		Возврат ПодтверждениеПоступленияТоваровПоУведомлениюОбОтгрузкеМаркированныхТоваровXML2_40(ДокументСсылка);
	КонецЕсли;
	
КонецФункции

#Область Версия2_40

Функция ПодтверждениеПоступленияТоваровПоУведомлениюОбОтгрузкеМаркированныхТоваровXML2_40(ДокументСсылка)
	
	СообщенияXML = Новый Массив;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	УведомлениеОПоступлении.Дата          КАК Дата,
	|	УведомлениеОПоступлении.НомерГИСМ     КАК НомерГИСМ,
	|	Неопределено                          КАК Основание,
	|	УведомлениеОПоступлении.Организация   КАК Организация,
	|	УведомлениеОПоступлении.Подразделение КАК Подразделение
	|ИЗ
	|	Документ.УведомлениеОПоступленииМаркированныхТоваровГИСМ КАК УведомлениеОПоступлении
	|ГДЕ
	|	УведомлениеОПоступлении.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КиЗКПолучению.НомерКиЗ                                    КАК НомерКиЗ,
	|	КиЗКПолучению.ДокументПоступления                         КАК ДокументПоступления,
	|	КиЗКПолучению.ДокументПоступления.Дата                    КАК ДатаДокументаПоступления,
	|	КиЗКПолучению.ДокументПоступления.НомерВходящегоДокумента КАК НомерВходящегоДокумента,
	|	КиЗКПолучению.ДокументПоступления.ДатаВходящегоДокумента  КАК ДатаВходящегоДокумента
	|ИЗ
	|	Документ.УведомлениеОПоступленииМаркированныхТоваровГИСМ.НомераКиЗ КАК КиЗКПолучению
	|ГДЕ
	|	  КиЗКПолучению.Ссылка = &Ссылка
	|	И КиЗКПолучению.СостояниеПодтверждения = ЗНАЧЕНИЕ(Перечисление.СостоянияОтправкиПодтвержденияГИСМ.КПередаче)
	|ИТОГИ
	|	МАКСИМУМ(ДатаДокументаПоступления)
	|ПО
	|	ДокументПоступления");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.ВыполнитьПакет();
	Шапка                          = Результат[0].Выбрать();
	ВыборкаПоДокументамПоступления = Результат[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Если Не Шапка.Следующий()
		ИЛИ ВыборкаПоДокументамПоступления.Количество() = 0 Тогда
		
		СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
		СообщениеXML.Документ = ДокументСсылка;
		СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
			Перечисления.ОперацииОбменаГИСМ.ПередачаПодтверждения, ДокументСсылка);
		СообщениеXML.ТекстОшибки = НСтр("ru = 'Нет данных для выгрузки.'");
		СообщенияXML.Добавить(СообщениеXML);
		Возврат СообщенияXML;
		
	КонецЕсли;
	
	РеквизитыОгранизации = ИнтеграцияГИСМВызовСервера.ИННКППGLNОрганизации(Шапка.Организация, Шапка.Подразделение);
	
	ИмяТипа   = "query";
	ИмяПакета = "move_commit_signs";
	
	Пока ВыборкаПоДокументамПоступления.Следующий() Цикл
		
		СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
		СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
			Перечисления.ОперацииОбменаГИСМ.ПередачаПодтверждения, ДокументСсылка);
		
		ПередачаДанных = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа);
		
		ПодтверждениеПоступления = ИнтеграцияГИСМ.ОбъектXDTO(ИмяПакета);
		ПодтверждениеПоступления.action_id     = ПодтверждениеПоступления.action_id;
		ПодтверждениеПоступления.sender_gln    = РеквизитыОгранизации.GLN;
		ПодтверждениеПоступления.move_order_id = Шапка.НомерГИСМ;
		
		ХранилищеВременныхДат = Новый Соответствие;
		ИнтеграцияГИСМ.УстановитьДатуСЧасовымПоясом(
			ПодтверждениеПоступления,
			"receive_date",
			ВыборкаПоДокументамПоступления.ДатаДокументаПоступления,
			ХранилищеВременныхДат);
		
		ПодтверждениеПоступления.commits = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(ПодтверждениеПоступления, "commits");
		
		Выборка = ВыборкаПоДокументамПоступления.Выбрать();
		Пока Выборка.Следующий() Цикл
			
			ПодтверждениеПоступления.commits.sign_num.Добавить(Выборка.НомерКиЗ);
			
		КонецЦикла;
		
		ПередачаДанных.version    = ПередачаДанных.version;
		ПередачаДанных[ИмяПакета] = ПодтверждениеПоступления;
		
		ТекстСообщенияXML = ИнтеграцияГИСМ.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа);
		ТекстСообщенияXML = ИнтеграцияГИСМ.ПреобразоватьВременныеДаты(ХранилищеВременныхДат, ТекстСообщенияXML);
		
		СообщениеXML.ТекстСообщенияXML  = ТекстСообщенияXML;
		СообщениеXML.КонвертSOAP = ИнтеграцияГИСМВызовСервера.ПоместитьТекстСообщенияXMLВКонвертSOAP(ТекстСообщенияXML);
		
		СообщениеXML.ТипСообщения = Перечисления.ТипыСообщенийГИСМ.Исходящее;
		СообщениеXML.Организация  = Шапка.Организация;
		СообщениеXML.Операция     = Перечисления.ОперацииОбменаГИСМ.ПередачаПодтверждения;
		СообщениеXML.Документ     = ДокументСсылка;
		СообщениеXML.Основание    = Шапка.Основание;
		СообщениеXML.Версия       = 0;
		
		СообщенияXML.Добавить(СообщениеXML);
		
	КонецЦикла;
	
	Возврат СообщенияXML;
	
КонецФункции

#КонецОбласти

#Область Версия2_41

Функция ПодтверждениеПоступленияТоваровПоУведомлениюОбОтгрузкеМаркированныхТоваровXML2_41(ДокументСсылка)
	
	СообщенияXML = Новый Массив;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	УведомлениеОПоступлении.Дата          КАК Дата,
	|	УведомлениеОПоступлении.НомерГИСМ     КАК НомерГИСМ,
	|	Неопределено                          КАК Основание,
	|	УведомлениеОПоступлении.Организация   КАК Организация,
	|	УведомлениеОПоступлении.Подразделение КАК Подразделение
	|ИЗ
	|	Документ.УведомлениеОПоступленииМаркированныхТоваровГИСМ КАК УведомлениеОПоступлении
	|ГДЕ
	|	УведомлениеОПоступлении.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КиЗКПолучению.НомерСтроки                                 КАК НомерСтроки,
	|	КиЗКПолучению.НомерКиЗ                                    КАК НомерКиЗ,
	|	КиЗКПолучению.RFIDTID                                     КАК TID,
	|	КиЗКПолучению.RFIDEPC                                     КАК EPC,
	|	КиЗКПолучению.ДокументПоступления                         КАК ДокументПоступления,
	|	КиЗКПолучению.ДокументПоступления.Дата                    КАК ДатаДокументаПоступления,
	|	КиЗКПолучению.ДокументПоступления.НомерВходящегоДокумента КАК НомерВходящегоДокумента,
	|	КиЗКПолучению.ДокументПоступления.ДатаВходящегоДокумента  КАК ДатаВходящегоДокумента
	|ИЗ
	|	Документ.УведомлениеОПоступленииМаркированныхТоваровГИСМ.НомераКиЗ КАК КиЗКПолучению
	|ГДЕ
	|	  КиЗКПолучению.Ссылка = &Ссылка
	|	И КиЗКПолучению.СостояниеПодтверждения = ЗНАЧЕНИЕ(Перечисление.СостоянияОтправкиПодтвержденияГИСМ.КПередаче)
	|ИТОГИ
	|	МАКСИМУМ(ДатаДокументаПоступления)
	|ПО
	|	ДокументПоступления");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.ВыполнитьПакет();
	Шапка                          = Результат[0].Выбрать();
	ВыборкаПоДокументамПоступления = Результат[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Если Не Шапка.Следующий()
		ИЛИ ВыборкаПоДокументамПоступления.Количество() = 0 Тогда
		
		СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
		СообщениеXML.Документ = ДокументСсылка;
		СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
			Перечисления.ОперацииОбменаГИСМ.ПередачаПодтверждения, ДокументСсылка);
		СообщениеXML.ТекстОшибки = НСтр("ru = 'Нет данных для выгрузки.'");
		СообщенияXML.Добавить(СообщениеXML);
		Возврат СообщенияXML;
		
	КонецЕсли;
	
	РеквизитыОгранизации = ИнтеграцияГИСМВызовСервера.ИННКППGLNОрганизации(Шапка.Организация, Шапка.Подразделение);
	
	ИмяТипа   = "query";
	ИмяПакета = "move_commit_signs";
	
	Пока ВыборкаПоДокументамПоступления.Следующий() Цикл
		
		СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
		СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
			Перечисления.ОперацииОбменаГИСМ.ПередачаПодтверждения, ДокументСсылка);
		
		ПередачаДанных = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа);
		
		ПодтверждениеПоступления = ИнтеграцияГИСМ.ОбъектXDTO(ИмяПакета);
		ПодтверждениеПоступления.action_id     = ПодтверждениеПоступления.action_id;
		ПодтверждениеПоступления.sender_gln    = РеквизитыОгранизации.GLN;
		ПодтверждениеПоступления.move_order_id = Шапка.НомерГИСМ;
		
		ХранилищеВременныхДат = Новый Соответствие;
		ИнтеграцияГИСМ.УстановитьДатуСЧасовымПоясом(
			ПодтверждениеПоступления,
			"receive_date",
			ВыборкаПоДокументамПоступления.ДатаДокументаПоступления,
			ХранилищеВременныхДат);
		
		ПодтверждениеПоступления.details = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(ПодтверждениеПоступления, "details");
		
		СтрокаТЧ = ВыборкаПоДокументамПоступления.Выбрать();
		Пока СтрокаТЧ.Следующий() Цикл
			
			Если Не ЗначениеЗаполнено(СтрокаТЧ.НомерКиЗ)
				И Не ЗначениеЗаполнено(СтрокаТЧ.TID)
				И Не ЗначениеЗаполнено(СтрокаТЧ.EPC) Тогда
				ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
					СообщениеXML,
					СтрШаблон(НСтр("ru = 'В строке %1 не указаны данные о КиЗ.'"),
						СтрокаТЧ.НомерСтроки));
				Продолжить;
			КонецЕсли;
			
			НоваяСтрока = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(ПодтверждениеПоступления.details, "sign");
			
			Если ЗначениеЗаполнено(СтрокаТЧ.НомерКиЗ) Тогда
				Попытка
					НоваяСтрока.sign_num.Добавить(СтрокаТЧ.НомерКиЗ);
				Исключение
					ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
						СообщениеXML,
						СтрШаблон(НСтр("ru = 'В строке %1 указан некорректный номер КиЗ ""%2"".'"),
							СтрокаТЧ.НомерСтроки,
							СтрокаТЧ.НомерКиЗ));
				КонецПопытки;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаТЧ.TID) Тогда
				Попытка
					НоваяСтрока.sign_tid.Добавить(СтрокаТЧ.TID);
				Исключение
					ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
						СообщениеXML,
						СтрШаблон(НСтр("ru = 'В строке %1 указан некорректный TID ""%2"".'"),
							СтрокаТЧ.НомерСтроки,
							СтрокаТЧ.TID));
				КонецПопытки;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрокаТЧ.EPC) Тогда
				Попытка
					НоваяСтрока.sign_sgtin.Добавить(МенеджерОборудованияКлиентСервер.ПреобразоватьHEXВБинарнуюСтроку(СтрокаТЧ.EPC));
				Исключение
					ИнтеграцияГИСМКлиентСервер.ДобавитьТекстОшибки(
						СообщениеXML,
						СтрШаблон(НСтр("ru = 'В строке %1 указан некорректный EPC ""%2"".'"),
							СтрокаТЧ.НомерСтроки,
							СтрокаТЧ.EPC));
				КонецПопытки;
			КонецЕсли;
			
			ПодтверждениеПоступления.details.sign.Добавить(НоваяСтрока);
			
		КонецЦикла;
		
		ПередачаДанных.version    = ПередачаДанных.version;
		ПередачаДанных[ИмяПакета] = ПодтверждениеПоступления;
		
		ТекстСообщенияXML = ИнтеграцияГИСМ.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа);
		ТекстСообщенияXML = ИнтеграцияГИСМ.ПреобразоватьВременныеДаты(ХранилищеВременныхДат, ТекстСообщенияXML);
		
		СообщениеXML.ТекстСообщенияXML  = ТекстСообщенияXML;
		СообщениеXML.КонвертSOAP = ИнтеграцияГИСМВызовСервера.ПоместитьТекстСообщенияXMLВКонвертSOAP(ТекстСообщенияXML);
		
		СообщениеXML.ТипСообщения = Перечисления.ТипыСообщенийГИСМ.Исходящее;
		СообщениеXML.Организация  = Шапка.Организация;
		СообщениеXML.Операция     = Перечисления.ОперацииОбменаГИСМ.ПередачаПодтверждения;
		СообщениеXML.Документ     = ДокументСсылка;
		СообщениеXML.Основание    = Шапка.Основание;
		СообщениеXML.Версия       = 0;
		
		СообщенияXML.Добавить(СообщениеXML);
		
	КонецЦикла;
	
	Возврат СообщенияXML;
	
КонецФункции

#КонецОбласти

Функция ЗакрытиеУведомленияОПоступленииМаркированныхТоваровXML(ДокументСсылка)
	
	СообщенияXML = Новый Массив;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Неопределено                            КАК Основание,
	|	УведомлениеОПоступлении.Организация     КАК Организация,
	|	Значение(Справочник.СтруктурныеЕдиницы.ПустаяСсылка) КАК Подразделение,
	|	УведомлениеОПоступлении.НомерГИСМ       КАК НомерГИСМ
	|ИЗ
	|	Документ.УведомлениеОПоступленииМаркированныхТоваровГИСМ КАК УведомлениеОПоступлении
	|ГДЕ
	|	УведомлениеОПоступлении.Ссылка = &Ссылка
	|");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.Выполнить();
	Шапка = Результат.Выбрать();
	Если Не Шапка.Следующий() Тогда
		
		СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
		СообщениеXML.Документ = ДокументСсылка;
		СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
			Перечисления.ОперацииОбменаГИСМ.ПередачаЗакрытияЗаявки, ДокументСсылка);
		СообщениеXML.ТекстОшибки = НСтр("ru = 'Нет данных для выгрузки.'");
		СообщенияXML.Добавить(СообщениеXML);
		Возврат СообщенияXML;
		
	КонецЕсли;
	
	РеквизитыОгранизации = ИнтеграцияГИСМВызовСервера.ИННКППGLNОрганизации(Шапка.Организация, Шапка.Подразделение);
	
	СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
	СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
			Перечисления.ОперацииОбменаГИСМ.ПередачаЗакрытияЗаявки, ДокументСсылка);
	
	ИмяТипа   = "query";
	ИмяПакета = "move_order_commit";
	
	ПередачаДанных = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа);
	
	ЗакрытиеУведомленияОПоступленииМаркированныхТоваров = ИнтеграцияГИСМ.ОбъектXDTO(ИмяПакета);
	ЗакрытиеУведомленияОПоступленииМаркированныхТоваров.action_id     = ЗакрытиеУведомленияОПоступленииМаркированныхТоваров.action_id;
	ЗакрытиеУведомленияОПоступленииМаркированныхТоваров.sender_gln    = РеквизитыОгранизации.GLN;
	ЗакрытиеУведомленияОПоступленииМаркированныхТоваров.move_order_id = Шапка.НомерГИСМ;
	
	ПередачаДанных.version    = ПередачаДанных.version;
	ПередачаДанных[ИмяПакета] = ЗакрытиеУведомленияОПоступленииМаркированныхТоваров;
	
	ТекстСообщенияXML = ИнтеграцияГИСМ.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа);
	
	СообщениеXML.ТекстСообщенияXML  = ТекстСообщенияXML;
	СообщениеXML.КонвертSOAP = ИнтеграцияГИСМВызовСервера.ПоместитьТекстСообщенияXMLВКонвертSOAP(ТекстСообщенияXML);
	
	СообщениеXML.ТипСообщения = Перечисления.ТипыСообщенийГИСМ.Исходящее;
	СообщениеXML.Организация  = Шапка.Организация;
	СообщениеXML.Операция     = Перечисления.ОперацииОбменаГИСМ.ПередачаЗакрытияЗаявки;
	СообщениеXML.Документ     = ДокументСсылка;
	СообщениеXML.Основание    = Шапка.Основание;
	СообщениеXML.Версия       = 0;
	
	СообщенияXML.Добавить(СообщениеXML);
	
	Возврат СообщенияXML;
	
КонецФункции

Функция АннулированиеУведомленияОПоступленииМаркированныхТоваровXML(ДокументСсылка)
	
	СообщенияXML = Новый Массив;
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Неопределено                          КАК Основание,
	|	УведомлениеОПоступлении.Организация   КАК Организация,
	|	УведомлениеОПоступлении.Подразделение КАК Подразделение,
	|	УведомлениеОПоступлении.НомерГИСМ     КАК НомерГИСМ
	|ИЗ
	|	Документ.УведомлениеОПоступленииМаркированныхТоваровГИСМ КАК УведомлениеОПоступлении
	|ГДЕ
	|	УведомлениеОПоступлении.Ссылка = &Ссылка
	|");
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Результат = Запрос.Выполнить();
	Шапка = Результат.Выбрать();
	Если Не Шапка.Следующий() Тогда
		
		СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
		СообщениеXML.Документ = ДокументСсылка;
		СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
			Перечисления.ОперацииОбменаГИСМ.ПередачаАннулирования, ДокументСсылка);
		СообщениеXML.ТекстОшибки = НСтр("ru = 'Нет данных для выгрузки.'");
		СообщенияXML.Добавить(СообщениеXML);
		Возврат СообщенияXML;
		
	КонецЕсли;
	
	РеквизитыОгранизации = ИнтеграцияГИСМВызовСервера.ИННКППGLNОрганизации(Шапка.Организация, Шапка.Подразделение);
	
	СообщениеXML = ИнтеграцияГИСМКлиентСервер.СтруктураСообщенияXML();
	СообщениеXML.Описание = ИнтеграцияГИСМ.ОписаниеОперацииПередачиДанных(
		Перечисления.ОперацииОбменаГИСМ.ПередачаАннулирования, ДокументСсылка);
	
	ИмяТипа   = "query";
	ИмяПакета = "move_order_cancel";
	
	ПередачаДанных = ИнтеграцияГИСМ.ОбъектXDTOПоИмениСвойства(Неопределено, ИмяТипа);
	
	АннулированиеУведомленияОПоступлении = ИнтеграцияГИСМ.ОбъектXDTO(ИмяПакета);
	АннулированиеУведомленияОПоступлении.action_id     = АннулированиеУведомленияОПоступлении.action_id;
	АннулированиеУведомленияОПоступлении.sender_gln    = РеквизитыОгранизации.GLN;
	АннулированиеУведомленияОПоступлении.move_order_id = Шапка.НомерГИСМ;
	
	ПередачаДанных.version    = ПередачаДанных.version;
	ПередачаДанных[ИмяПакета] = АннулированиеУведомленияОПоступлении;
	
	ТекстСообщенияXML = ИнтеграцияГИСМ.ОбъектXDTOВXML(ПередачаДанных, ИмяТипа);
	
	СообщениеXML.ТекстСообщенияXML  = ТекстСообщенияXML;
	СообщениеXML.КонвертSOAP = ИнтеграцияГИСМВызовСервера.ПоместитьТекстСообщенияXMLВКонвертSOAP(ТекстСообщенияXML);
	
	СообщениеXML.ТипСообщения = Перечисления.ТипыСообщенийГИСМ.Исходящее;
	СообщениеXML.Организация  = Шапка.Организация;
	СообщениеXML.Операция     = Перечисления.ОперацииОбменаГИСМ.ПередачаАннулирования;
	СообщениеXML.Документ     = ДокументСсылка;
	СообщениеXML.Основание    = Шапка.Основание;
	СообщениеXML.Версия       = 0;
	
	СообщенияXML.Добавить(СообщениеXML);
	
	Возврат СообщенияXML;
	
КонецФункции

#КонецОбласти

#Область Отчеты

// Заполняет список команд отчетов.
// 
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - состав полей см. в функции МенюОтчеты.СоздатьКоллекциюКомандОтчетов
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов) Экспорт
	
	ИнтеграцияГИСМПереопределяемый.ДобавитьКомандуСтруктураПодчиненности(КомандыОтчетов);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли

