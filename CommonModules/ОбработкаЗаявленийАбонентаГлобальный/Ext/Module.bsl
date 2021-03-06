﻿
#Область ПрограммныйИнтерфейс

Процедура СообщитьОбОдобренныхЗаявленияхАбонента() Экспорт
	
	ЕстьОтправленныеЗаявления = ОбработкаЗаявленийАбонентаВызовСервера.ОтправленныеЗаявленияАбонентов().Количество() > 0;
	
	Если ЕстьОтправленныеЗаявления Тогда
		
		Заявление = ОбработкаЗаявленийАбонентаВызовСервера.СледующееЗаявлениеТребующееРеакцииПользователя();
		
		Если ЗначениеЗаполнено(Заявление) Тогда
			
			Если НЕ ФормаОповещенияИлиМастераУжеОткрыта() Тогда
				
				ОписаниеОповещения = Новый ОписаниеОповещения(
					"ПослеЗакрытияФормыОповещения", 
					ОбработкаЗаявленийАбонентаКлиент);
				
				ПараметрыФормы = Новый Структура();
				ПараметрыФормы.Вставить("Заявление", Заявление);

				ОткрытьФорму(
					"ОбщаяФорма.ОповещениеОбОдобренииЗаявленияАбонента",
					ПараметрыФормы,
					,
					,
					ВариантОткрытияОкна.ОтдельноеОкно,
					,
					ОписаниеОповещения);
			
			КонецЕсли;
			
		Иначе
			
			// Отключения обработчика не делаем,
			// так как заявление может изменить статус, а обработчик будет отключен.
			// Отключим только если нет ни одного отправленного.
			
		КонецЕсли;
		
		// Переходим к следующему заявлению.
		ОбработкаЗаявленийАбонентаКлиент.ПодключитьОбработчикПроверкиЗаявлений();
	
	Иначе
		
		// Отключаем только в случае, если нет отправленных.
		ОбработкаЗаявленийАбонентаКлиент.ОтключитьОбработчикПроверкиЗаявлений();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ФормаОповещенияИлиМастераУжеОткрыта()
	
	Для Каждого ОткрытоеОкно Из ПолучитьОкна() Цикл
		Если ОткрытоеОкно <> Неопределено Тогда
			ТекущаяФорма = ОткрытоеОкно.ПолучитьСодержимое();
			Если ТипЗнч(ТекущаяФорма) = Тип("УправляемаяФорма") Тогда
				
				ЭтоФормаОповещения 			= ТекущаяФорма.ИмяФормы = "ОбщаяФорма.ОповещениеОбОдобренииЗаявленияАбонента";
				ЭтоФормаНастроки 			= СтрНайти(ТекущаяФорма.ИмяФормы, "МастерФормированияЗаявкиНаПодключениеНастройкаПрограммы") <> 0;
				ЭтоФормаПервичногоМастера 	= СтрНайти(ТекущаяФорма.ИмяФормы, "МастерФормированияЗаявкиНаПодключение") <> 0;
				ЭтоФормаВторичногоМастера 	= СтрНайти(ТекущаяФорма.ИмяФормы, "МастерФормированияЗаявкиНаИзменениеПараметровПодключения") <> 0;
				
				Если ЭтоФормаОповещения
					ИЛИ ЭтоФормаНастроки
					ИЛИ ЭтоФормаПервичногоМастера
					ИЛИ ЭтоФормаВторичногоМастера Тогда
					
					Возврат Истина;
					
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции
	
#КонецОбласти
