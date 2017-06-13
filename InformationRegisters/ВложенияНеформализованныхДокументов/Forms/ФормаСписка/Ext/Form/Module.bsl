﻿&НаСервере
Перем КонтекстЭДОСервер;

&НаКлиенте
Перем КонтекстЭДОКлиент;

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаВыгрузить(Команда)
	
	ТекСтроки = Элементы.РегистрСведенийСписок.ВыделенныеСтроки;
	Если ТекСтроки.Количество() <> 0 Тогда
		
		Если НЕ ПолучитьДанныеНаСервере(ТекСтроки) ИЛИ ВыборкаСодержимого.Количество() = 0 Тогда
			Возврат;
		КонецЕсли;
		
		МассивИменФайлов = Новый Массив;
		МассивОписанийПолучаемыеФайлы = Новый Массив;
		Для Каждого Контейнер Из ВыборкаСодержимого Цикл 
			МассивИменФайлов.Добавить(Контейнер.КороткоеИмяФайла);
			ОписаниеФайла = Новый ОписаниеПередаваемогоФайла(Контейнер.КороткоеИмяФайла, Контейнер.АдресСодержимого); 
			МассивОписанийПолучаемыеФайлы.Добавить(ОписаниеФайла);
		КонецЦикла;
		
		ОперацииСФайламиЭДКОКлиент.СохранитьФайлы(МассивОписанийПолучаемыеФайлы);
		
	Иначе
		
		ПоказатьПредупреждение(, "Выберите файлы, которые следует сохранить на диск, и повторите попытку.
		|Для множественного выбора используйте клавишу Ctrl.");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОчиститьТаблицуИХранилище()
	
	Если ВыборкаСодержимого.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Выборка Из ВыборкаСодержимого Цикл 
		УдалитьИзВременногоХранилища(Выборка.АдресСодержимого);
	КонецЦикла;
	
	ВыборкаСодержимого.Очистить();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеНаСервере(ТекСтроки)
	
	Если КонтекстЭДОСервер = Неопределено Тогда 
		// инициализируем контекст ЭДО - модуль обработки
		ТекстСообщения = "";
		КонтекстЭДОСервер = ДокументооборотСКОВызовСервера.ПолучитьОбработкуЭДО(ТекстСообщения);
		Если КонтекстЭДОСервер = Неопределено Тогда 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ОчиститьТаблицуИХранилище();
	
	Для Каждого ТекСтрока Из ТекСтроки Цикл
		МенеджерЗаписи = РегистрыСведений.ВложенияНеформализованныхДокументов.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.НеформализованныйДокумент = ТекСтрока.НеформализованныйДокумент;
		МенеджерЗаписи.ИмяФайла = ТекСтрока.ИмяФайла;
		МенеджерЗаписи.Прочитать();

		НоваяСтрока = ВыборкаСодержимого.Добавить();
		ГУИД = Новый УникальныйИдентификатор;
		НоваяСтрока.КороткоеИмяФайла = МенеджерЗаписи.ИмяФайла;
        НоваяСтрока.АдресСодержимого = ПоместитьВоВременноеХранилище(МенеджерЗаписи.Данные.Получить(), ГУИД);
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	
КонецПроцедуры

#КонецОбласти