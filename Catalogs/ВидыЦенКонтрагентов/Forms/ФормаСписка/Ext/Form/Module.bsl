﻿
&НаКлиенте
Перем ФормаДлительнойОперации;

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПослеВыполненияФоновогоЗадания()
	
	ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
	
	ПоказатьПредупреждение(,Нстр("ru ='Цены номенклатуры.
	|Загрузка данных завершена.'"));
	
КонецПроцедуры

&НаСервере
Процедура ФоновоеЗаданиеВыполнено(Прогресс)
	
	Попытка
		
		ПараметрыДлительнойОперации.ЗаданиеВыполнено = ДлительныеОперации.ЗаданиеВыполнено(ПараметрыДлительнойОперации.ИдентификаторЗадания);
		
		Если НЕ ПараметрыДлительнойОперации.ЗаданиеВыполнено Тогда
			
			Прогресс = ДлительныеОперации.ПрочитатьПрогресс(ПараметрыДлительнойОперации.ИдентификаторЗадания);
			
		КонецЕсли;
		
	Исключение
		
		ПараметрыДлительнойОперации.ЗаданиеВыполнено = Истина;
		ВызватьИсключение Нстр("ru ='Ошибка'") + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ФоновоеЗаданиеПроверитьНаКлиенте()
	Перем Прогресс;
	
	ФоновоеЗаданиеВыполнено(Прогресс);
	
	Если ПараметрыДлительнойОперации.ЗаданиеВыполнено = Истина Тогда
		
		ПослеВыполненияФоновогоЗадания();
		
	Иначе
		
		Если ФормаДлительнойОперации = Неопределено Тогда
			
			ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтотОбъект, ПараметрыДлительнойОперации.ИдентификаторЗадания);
			
		ИначеЕсли ТипЗнч(Прогресс) = Тип("Структура")
			И Прогресс.Свойство("Текст") Тогда
			
			МассивСтрок = Новый Массив;
			МассивСтрок.Добавить(НСтр("ru = 'Пожалуйста, подождите...'"));
			МассивСтрок.Добавить(Символы.ПС);
			МассивСтрок.Добавить(Прогресс.Текст);
			
			ФормаДлительнойОперации.Элементы.ДекорацияПоясняющийТекстДлительнойОперации.Заголовок = СтрСоединить(МассивСтрок);
			
		КонецЕсли;
		
		ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыДлительнойОперации.ПараметрыОбработчика);
		ПодключитьОбработчикОжидания("ФоновоеЗаданиеПроверитьНаКлиенте", ПараметрыДлительнойОперации.ПараметрыОбработчика.ТекущийИнтервал, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьНеобходимостьПодключенияОбработчикаОжидания()
	
	Если ПараметрыДлительнойОперации.ЗаданиеВыполнено = Истина Тогда
		
		ПослеВыполненияФоновогоЗадания();
		
	Иначе
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыДлительнойОперации.ПараметрыОбработчика);
		ПодключитьОбработчикОжидания("ФоновоеЗаданиеПроверитьНаКлиенте", 1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
// Процедура - обработчик события ПриСозданииНаСервере.
//
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПараметрыДлительнойОперации = Новый Структура;
	ПараметрыДлительнойОперации.Вставить("ЗаданиеВыполнено", Неопределено);
	ПараметрыДлительнойОперации.Вставить("ПараметрыОбработчика", Неопределено);
	ПараметрыДлительнойОперации.Вставить("ИдентификаторЗадания", "");
	
	// СтандартныеПодсистемы.ЗагрузкаДанныхИзВнешнегоИсточника
	ЗагрузкаДанныхИзВнешнегоИсточника.ПриСозданииНаСервере(Метаданные.РегистрыСведений.ЦеныНоменклатурыКонтрагентов, НастройкиЗагрузкиДанных, ЭтотОбъект, Ложь);
	// Конец СтандартныеПодсистемы.ЗагрузкаДанныхИзВнешнегоИсточника
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
КонецПроцедуры // ПриСозданииНаСервере()

#КонецОбласти

#Область ОбработчикиБиблиотек

// СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла
&НаКлиенте
Процедура ПоказатьПомощникЗагрузкиДанныхИзВнешнегоИсточника()
	
	ДанныеТекущейСтроки = Элементы.Список.ТекущиеДанные;
	Если ДанныеТекущейСтроки = Неопределено Тогда
		
		ТекстСообщения = НСтр("ru ='Необходимо выделить вид цен контрагента, для которого планируется загрузить цены'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Возврат;
		
	КонецЕсли;
	
	НастройкиЗагрузкиДанных.Вставить("ВидЦенКонтрагента", ДанныеТекущейСтроки.Ссылка);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузкаДанныхИзВнешнегоИсточникаОбработкаРезультата", ЭтотОбъект, НастройкиЗагрузкиДанных);
	
	ЗагрузкаДанныхИзВнешнегоИсточникаКлиент.ПоказатьФормуЗагрузкиДанныхИзВнешнегоИсточника(НастройкиЗагрузкиДанных, ОписаниеОповещения, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьЦеныИзВнешнегоИсточника(Команда)
	
	ПоказатьПомощникЗагрузкиДанныхИзВнешнегоИсточника();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузкаДанныхИзВнешнегоИсточникаОбработкаРезультата(РезультатЗагрузки, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатЗагрузки) = Тип("Структура") Тогда
		
		Если РезультатЗагрузки.ОписаниеДействия = "ИзменитьСпособЗагрузкиДанныхИзВнешнегоИсточника" Тогда
		
			ЗагрузкаДанныхИзВнешнегоИсточника.ИзменитьСпособЗагрузкиДанныхИзВнешнегоИсточника(НастройкиЗагрузкиДанных.ИмяФормыЗагрузкиДанныхИзВнешнихИсточников);
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузкаДанныхИзВнешнегоИсточникаОбработкаРезультата", ЭтотОбъект, НастройкиЗагрузкиДанных);
			ЗагрузкаДанныхИзВнешнегоИсточникаКлиент.ПоказатьФормуЗагрузкиДанныхИзВнешнегоИсточника(НастройкиЗагрузкиДанных, ОписаниеОповещения, ЭтотОбъект);
			
		ИначеЕсли РезультатЗагрузки.ОписаниеДействия = "ОбработатьПодготовленныеДанные" Тогда
			
			ОбработатьПодготовленныеДанные(РезультатЗагрузки);
			ПроверитьНеобходимостьПодключенияОбработчикаОжидания();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьПодготовленныеДанные(РезультатЗагрузки)
	
	ПараметрыВызоваСервера = Новый Структура;
	ПараметрыВызоваСервера.Вставить("НастройкиЗагрузкиДанных", РезультатЗагрузки.НастройкиЗагрузкиДанных);
	ПараметрыВызоваСервера.Вставить("ТаблицаСопоставленияДанных", ДанныеФормыВЗначение(РезультатЗагрузки.ТаблицаСопоставленияДанных, Тип("ТаблицаЗначений")));
	
	ИмяМетода = "РегистрыСведений.ЦеныНоменклатурыКонтрагентов.ОбработатьПодготовленныеДанные";
	Описание = НСтр("ru = 'Подсистема ЗагрузкаДанныхИзВнешнегоИсточника: Выполнение серверного метода загрузки результата'");
	
	РезультатФоновогоЗадания = ДлительныеОперации.ЗапуститьВыполнениеВФоне(УникальныйИдентификатор, ИмяМетода, ПараметрыВызоваСервера, Описание);
	ЗаполнитьЗначенияСвойств(ПараметрыДлительнойОперации, РезультатФоновогоЗадания);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла

#КонецОбласти