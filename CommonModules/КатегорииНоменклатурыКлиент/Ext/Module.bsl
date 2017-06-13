﻿
#Область ПрограммныйИнтерфейс

Процедура КатегорияНоменклатурыАвтоПодбор(Текст, ДанныеВыбора, ПараметрыПолученияДанных, ПоказыватьСуществующие = Истина) Экспорт
	
	ДанныеВыбора = КатегорииНоменклатурыСервер.СписокАвтоПодбораКатегорииТоваровИУслуг(Текст, ПараметрыПолученияДанных, ПоказыватьСуществующие = Истина);
	
КонецПроцедуры

Процедура КатегорияНоменклатурыОбработкаВыбора(ВыбранноеЗначение, Родитель = Неопределено) Экспорт
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.КатегорииНоменклатуры") Тогда
		
		Возврат;
		
	ИначеЕсли ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.КлассификаторКатегорийНоменклатуры") Тогда
		
		Результат = Новый Структура("СозданоГрупп, СозданоЭлементов", 0, 0);
		ВыбранноеЗначение = КатегорииНоменклатурыСервер.КатегорияНоменклатурыПоКлассификатору(ВыбранноеЗначение, Родитель, Результат);
		
		Если Результат.СозданоГрупп <> 0 ИЛИ Результат.СозданоЭлементов <> 0 Тогда
			ТекстЗаголовка = НСтр("ru='Создание категорий 
			|из Яндекс.Маркета'");
			ТекстСообщения = НСтр("ru='%Группы%%Элементы%'");
			Если Результат.СозданоГрупп > 0 Тогда
				Группы = "групп (" + Результат.СозданоГрупп + "), ";
			Иначе
				Группы = "";
			КонецЕсли;
			Если Результат.СозданоЭлементов > 0 Тогда
				Элементы = "элементов (" + Результат.СозданоЭлементов + ")";
			Иначе
				Элементы = "";
			КонецЕсли;
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Группы%", Группы);
			ТекстСообщения = СтрЗаменить(ТекстСообщения, "%Элементы%", Элементы);
			
			ПоказатьОповещениеПользователя(ТекстЗаголовка,, ТекстСообщения, БиблиотекаКартинок.Информация32);
			
			Оповестить("Справочник.КатегорииНоменклатуры.СозданиеКатегорииИзКлассификатора", ВыбранноеЗначение);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ДеревоКатегорийПередНачаломДобавления(ТекущийЭлемент, Отказ) Экспорт
	
	ПараметрыОткрытия = Новый Структура("ТекущаяСтрока", ТекущийЭлемент);
	ОткрытьФорму("Справочник.КатегорииНоменклатуры.ФормаСписка", ПараметрыОткрытия);
	Отказ = Истина;
	
КонецПроцедуры

Процедура ДеревоКатегорийПередНачаломИзменения(ТекущийЭлемент, Отказ) Экспорт
	
	ПоказатьЗначение(, ТекущийЭлемент);
	Отказ = Истина;
	
КонецПроцедуры

#КонецОбласти
