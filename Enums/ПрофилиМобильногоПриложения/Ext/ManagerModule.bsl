﻿Функция ПолучитьСтроковоеПредставление(Профиль) Экспорт
	
	Если Профиль = Перечисления.ПрофилиМобильногоПриложения.Собственник Тогда
		Возврат "Собственник";
	ИначеЕсли Профиль = Перечисления.ПрофилиМобильногоПриложения.ТорговыйПредставитель Тогда
		Возврат "ТорговыйПредставитель";
	ИначеЕсли Профиль = Перечисления.ПрофилиМобильногоПриложения.СервисныйИнженер Тогда
		Возврат "СервисныйИнженер";
	ИначеЕсли Профиль = Перечисления.ПрофилиМобильногоПриложения.Продавец Тогда
		Возврат "Продавец";
	ИначеЕсли Профиль = Перечисления.ПрофилиМобильногоПриложения.ДетальнаяНастройка Тогда
		Возврат "ДетальнаяНастройка";
	КонецЕсли;
	
КонецФункции