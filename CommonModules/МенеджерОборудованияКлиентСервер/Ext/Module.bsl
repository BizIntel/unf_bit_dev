﻿
#Область ПрограммныйИнтерфейс

// Функция заполняет наименование рабочего места клиента по имени пользователя.
//
Процедура ЗаполнитьНаименованиеРабочегоМеста(Объект, ИмяПользователя) Экспорт
	
	ИмяПустойПользователь = НСтр("ru='<Пользователь>'");
	
	Если ПустаяСтрока(Объект.Наименование) Тогда
		
		Если ПустаяСтрока(ИмяПользователя) Тогда
			Объект.Наименование = "<" + ИмяПустойПользователь + ">";
		Иначе
			Объект.Наименование = Строка(ИмяПользователя);
		КонецЕсли;
		
		Если ПустаяСтрока(Объект.ИмяКомпьютера) Тогда
			Объект.Наименование = Объект.Наименование + "(" + Объект.Код           + ")";
		Иначе
			Объект.Наименование = Объект.Наименование + "(" + Объект.ИмяКомпьютера + ")";
		КонецЕсли;
		
	ИначеЕсли Не ПустаяСтрока(Строка(ИмяПользователя))
	          И Найти(Объект.Наименование, ИмяПустойПользователь) > 0 Тогда
	
		Объект.Наименование = СтрЗаменить(Объект.Наименование, ИмяПустойПользователь, Строка(ИмяПользователя));
	
	КонецЕсли;

КонецПроцедуры

// Функция возвращает пустую структуру прайс-листа для заполнения XDTO-пакета EquipmentService.
// 
// Возвращаемое значение:
//   - Подготовленная структура для прайс-листа.
//
Функция ПолучитьСтруктуруПрайсЛиста() Экспорт
	
	СтруктураПрайсЛиста = Новый Структура;
	СтруктураПрайсЛиста.Вставить("ПолнаяЗагрузка", Ложь);
	СтруктураПрайсЛиста.Вставить("Товары",        Новый Массив);
	СтруктураПрайсЛиста.Вставить("ГруппыТоваров", Новый Массив);
	СтруктураПрайсЛиста.Вставить("ДопСведения",   Новый Массив);
	СтруктураПрайсЛиста.Вставить("НомерПакета",   1);
	СтруктураПрайсЛиста.Вставить("ПакетовВсего",  1);
	СтруктураПрайсЛиста.Вставить("ВерсияФормата", 0);
	
	Возврат СтруктураПрайсЛиста;
	
КонецФункции

// Функция возвращает пустую структуру записи массива "Товары" прайс-листа
// для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруЗаписиМассиваТовары() Экспорт
	
	СтруктураЗаписиМассиваТовары = Новый Структура;
	
	СтруктураЗаписиМассиваТовары.Вставить("Код");
	СтруктураЗаписиМассиваТовары.Вставить("КодГруппы", "");
	СтруктураЗаписиМассиваТовары.Вставить("Наименование");
	СтруктураЗаписиМассиваТовары.Вставить("ИмеетХарактеристики", Ложь);
	СтруктураЗаписиМассиваТовары.Вставить("ИмеетУпаковки", Ложь);
	СтруктураЗаписиМассиваТовары.Вставить("Артикул");
	СтруктураЗаписиМассиваТовары.Вставить("ЕдиницаИзмерения");
	СтруктураЗаписиМассиваТовары.Вставить("СтавкаНДС", "");
	СтруктураЗаписиМассиваТовары.Вставить("Весовой", Ложь);
	СтруктураЗаписиМассиваТовары.Вставить("Штрихкод");
	СтруктураЗаписиМассиваТовары.Вставить("Остаток");
	СтруктураЗаписиМассиваТовары.Вставить("Услуга", Ложь);
	СтруктураЗаписиМассиваТовары.Вставить("Цена");
	СтруктураЗаписиМассиваТовары.Вставить("Упаковки", Новый Массив());
	СтруктураЗаписиМассиваТовары.Вставить("Характеристики", Новый Массив());
	СтруктураЗаписиМассиваТовары.Вставить("КодНалога");
	СтруктураЗаписиМассиваТовары.Вставить("Алкоголь");
	СтруктураЗаписиМассиваТовары.Вставить("Маркируемый");
	СтруктураЗаписиМассиваТовары.Вставить("КодВидаАлкогольнойПродукции");
	СтруктураЗаписиМассиваТовары.Вставить("ЕмкостьТары");
	СтруктураЗаписиМассиваТовары.Вставить("Крепость");
	СтруктураЗаписиМассиваТовары.Вставить("ИННПроизводителя");
	СтруктураЗаписиМассиваТовары.Вставить("КПППроизводителя");
	СтруктураЗаписиМассиваТовары.Вставить("УникальныйИдентификатор");
	
	Возврат СтруктураЗаписиМассиваТовары;
	
КонецФункции

// Функция возвращает пустую структуру массива товары
// для заполнения XDTO-пакета EquipmentService.
//
Функция ПолучитьСтруктуруМассиваТовары() Экспорт
	
	СтруктураПрайсЛиста = Новый Структура;
	СтруктураПрайсЛиста.Вставить("Товары",        Новый Массив);
	
	Возврат СтруктураПрайсЛиста;
	
КонецФункции

// Функция возвращает пустую структуру записи EPC.
// 
// Возвращаемое значение:
//  - Структура
//       Результат       - Результат декодирования (успешно или нет)
//       EPC             - Значение EPC в виде HEX строки
//       EPC_BIN         - Значение EPC в виде бинарной строки
//       Формат          - Распознанный формат данных SGTIN-96 или SGTIN-198  
//       GTIN            - GTIN 
//       СерийныйНомер   - Серийный номер SGTIN 
//       ПрефиксКомпании - Префикс компании
//       URI             - EPC Tag URI
//       
Функция ПолучитьСтруктуруЗаписиEPC() Экспорт
	
	СтруктураЗаписиEPC = Новый Структура;
	
	СтруктураЗаписиEPC.Вставить("Результат", False); // Результат декодирования (успешно или нет)
	СтруктураЗаписиEPC.Вставить("EPC");              // Значение EPC в виде HEX строки
	СтруктураЗаписиEPC.Вставить("EPC_BIN");          // Значение EPC в виде бинарной строки
	СтруктураЗаписиEPC.Вставить("Формат");           // Распознанный формат данных SGTIN-96 или SGTIN-198  
	СтруктураЗаписиEPC.Вставить("GTIN");             // GTIN 
	СтруктураЗаписиEPC.Вставить("СерийныйНомер");    // Серийный номер SGTIN 
	СтруктураЗаписиEPC.Вставить("ПрефиксКомпании");  // Префикс компании
	СтруктураЗаписиEPC.Вставить("URI");              // EPC Tag URI
	
	Возврат СтруктураЗаписиEPC;
	
КонецФункции

// Функция возвращает массив из пакетов данных.
//
Функция РазбитьПрайсЛистПоПакетам(СтруктураПрайсЛиста, КоличествоЭлементовВПакете) Экспорт
	
	МассивПакетов = Новый Массив;
	
	КоличествоЭлементов = СтруктураПрайсЛиста.ГруппыТоваров.Количество() + СтруктураПрайсЛиста.Товары.Количество() + СтруктураПрайсЛиста.ДопСведения.Количество();
	КоличествоПакетов   = ОпределитьКоличествоПакетов(КоличествоЭлементовВПакете, КоличествоЭлементов);
	
	Если КоличествоЭлементовВПакете = 0 Тогда
		КоличествоЭлементовВПакете = КоличествоЭлементов;
	КонецЕсли;
	
	Для НомерПакета = 1 По КоличествоПакетов Цикл
		
		СтруктураПакета = ПолучитьСтруктуруПрайсЛиста();
		СтруктураПакета.ПолнаяЗагрузка = СтруктураПрайсЛиста.ПолнаяЗагрузка;
		
		СтруктураПакета.НомерПакета = НомерПакета;
		СтруктураПакета.ПакетовВсего = КоличествоПакетов;
		
		Для НомерЭлемента = 1 По КоличествоЭлементовВПакете Цикл
			
			// Группы
			Если НЕ СтруктураПрайсЛиста.ГруппыТоваров.Количество() = 0 Тогда
				
				СтруктураПакета.ГруппыТоваров.Добавить(СтруктураПрайсЛиста.ГруппыТоваров[0]);
				СтруктураПрайсЛиста.ГруппыТоваров.Удалить(0);
				Продолжить;
			КонецЕсли;
			
			// Товары
			Если НЕ СтруктураПрайсЛиста.Товары.Количество() = 0 Тогда
				
				СтруктураПакета.Товары.Добавить(СтруктураПрайсЛиста.Товары[0]);
				СтруктураПрайсЛиста.Товары.Удалить(0);
				Продолжить;
			КонецЕсли;
			
			// ДопСведения
			Если НЕ СтруктураПрайсЛиста.ДопСведения.Количество() = 0 Тогда
				
				СтруктураПакета.ДопСведения.Добавить(СтруктураПрайсЛиста.ДопСведения[0]);
				СтруктураПрайсЛиста.ДопСведения.Удалить(0);
				Продолжить;
			КонецЕсли;
			
		КонецЦикла;
		
		МассивПакетов.Добавить(СтруктураПакета);
		
	КонецЦикла;
	
	Возврат МассивПакетов;
	
КонецФункции

// Расчет контрольной цифры для GTIN-8. 
//
// Параметры:
//  GTIN - Текстовая строка с GTIN-8. Может содержать числа от 0 до 9. 
// 
// Возвращаемое значение:
//   - Контрольный символ (число) рассчитанный по алгоритму для GTIN.
//
Функция РассчитатьКонтрольныйСимволGTIN8(Знач GTIN) Экспорт
	
	Сумма = 0;
	Коэффициент = 3;
	
	Для Сч = 1 По 7 Цикл
		ВремКодСимвола = КодСимвола(GTIN, Сч);
		Сумма  = Сумма + Коэффициент * (ВремКодСимвола - 48);
		Коэффициент = 4 - Коэффициент;
	КонецЦикла;
	Сумма = (10 - Сумма % 10) % 10;
	КонтрольныйСимвол = Символ(Сумма + 48);
	
	Возврат КонтрольныйСимвол;
	
КонецФункции

// Расчет контрольной цифры для GTIN-12. 
//
// Параметры:
//  GTIN - Текстовая строка с GTIN-12. Может содержать числа от 0 до 9. 
// 
// Возвращаемое значение:
//   - Контрольный символ (число) рассчитанный по алгоритму для GTIN.
//
Функция РассчитатьКонтрольныйСимволGTIN12(Знач GTIN) Экспорт
	
	Сумма = 0;
	Коэффициент = 3;
	
	Для Сч = 1 По 11 Цикл
		ВремКодСимвола = КодСимвола(GTIN, Сч);
		Сумма  = Сумма + Коэффициент * (ВремКодСимвола - 48);
		Коэффициент = 4 - Коэффициент;
	КонецЦикла;
	Сумма = (10 - Сумма % 10) % 10;
	КонтрольныйСимвол = Символ(Сумма + 48);
	
	Возврат КонтрольныйСимвол;
	
КонецФункции

// Расчет контрольной цифры для GTIN-13. 
//
// Параметры:
//  GTIN - Текстовая строка с GTIN-13. Может содержать числа от 0 до 9.
// 
// Возвращаемое значение:
//   - Контрольный символ (число) рассчитанный по алгоритму для GTIN.
//
Функция РассчитатьКонтрольныйСимволGTIN13(Знач GTIN) Экспорт
	
	Сумма = 0;
	Коэффициент = 1;
	
	Для Сч = 1 По 12 Цикл
		ВремКодСимвола = КодСимвола(GTIN, Сч);
		Сумма  = Сумма + Коэффициент * (ВремКодСимвола - 48);
		Коэффициент = 4 - Коэффициент;
	КонецЦикла;
	Сумма = (10 - Сумма % 10) % 10;
	КонтрольныйСимвол = Символ(Сумма + 48);
	
	Возврат КонтрольныйСимвол;
	
КонецФункции

// Расчет контрольной цифры для GTIN-14. 
//
// Параметры:
//  GTIN - Текстовая строка с GTIN-14. Может содержать числа от 0 до 9. 
// 
// Возвращаемое значение:
//   - Контрольный символ (число) рассчитанный по алгоритму для GTIN.
//
Функция РассчитатьКонтрольныйСимволGTIN14(Знач GTIN) Экспорт
	
	Сумма = 0;
	Коэффициент = 3;
	
	Для Сч = 1 По 13 Цикл
		ВремКодСимвола = КодСимвола(GTIN, Сч);
		Сумма  = Сумма + Коэффициент * (ВремКодСимвола - 48);
		Коэффициент = 4 - Коэффициент;
	КонецЦикла;
	Сумма = (10 - Сумма % 10) % 10;
	КонтрольныйСимвол = Символ(Сумма + 48);
	
	Возврат КонтрольныйСимвол;
	
КонецФункции

// Универсальная функция расчета контрольной цифры GTIN.
// GTIN допускает в формате GTIN-8, GTIN-12, GTIN-13, GTIN-14 c контрольным символом.
//
// Параметры:
//  GTIN - Текстовая строка с GTIN(c контрольным символом). Может содержать числа от 0 до 9.
// 
// Возвращаемое значение:
//   - Контрольный символ (число) рассчитанный по алгоритму для GTIN.
//
Функция РассчитатьКонтрольныйСимволGTIN(Знач GTIN) Экспорт
	
	Сумма = 0;
	ДлиннаGTIN = СтрДлина(GTIN);
	Коэффициент = ?(ДлиннаGTIN % 2 = 0, 3, 1); 
	
	Для Сч = 1 По ДлиннаGTIN - 1 Цикл
		ВремКодСимвола = КодСимвола(GTIN, Сч);
		Сумма  = Сумма + Коэффициент * (ВремКодСимвола - 48);
		Коэффициент = 4 - Коэффициент;
	КонецЦикла;
	Сумма = (10 - Сумма % 10) % 10;
	КонтрольныйСимвол = Символ(Сумма + 48);
	
	Возврат КонтрольныйСимвол;
	
КонецФункции

// Функция проверяет корректность GTIN.
// GTIN допускает в формате GTIN-8, GTIN-12, GTIN-13, GTIN-14 c контрольным символом.
//
// Параметры:
//  GTIN - Текстовая строка с GTIN(c контрольным символом). Может содержать числа от 0 до 9.
// 
// Возвращаемое значение:
//   - Булево  
//
Функция ПроверитьКорректностьGTIN(Знач GTIN) Экспорт
	
	Результат = (СтрДлина(GTIN) = 8) Или (СтрДлина(GTIN) = 12) Или (СтрДлина(GTIN) = 13) Или (СтрДлина(GTIN) = 14);
	Возврат Результат И РассчитатьКонтрольныйСимволGTIN(GTIN) = Прав(GTIN, 1);
	
КонецФункции

// Декодирование данных по значение EPC(HEX строка). Поддерживается формат SGTIN-96 и SGTIN-198.
//
// Параметры:
//   EPC - Строка содержащая значение банка EPC в HEX виде.
// 
// Возвращаемое значение:
//  - Структура
//       Результат       - Результат декодирования (успешно или нет)
//       EPC             - Значение EPC в виде HEX строки
//       EPC_BIN         - Значение EPC в виде бинарной строки
//       Формат          - Распознанный формат данных SGTIN-96 или SGTIN-198  
//       GTIN            - GTIN 
//       СерийныйНомер   - Серийный номер SGTIN 
//       ПрефиксКомпании - Префикс компании
//       URI             - EPC Tag URI
//       
Функция ДекодированиеДанныхSGTIN(EPC) Экспорт
	
	// Преобразовываем HEX строку значение банка EPC в бинарную строку.
	БитовыйМассив = ПреобразоватьHEXВБинарнуюСтроку(EPC);
	
	// Подготавливаем структура результата.
	СтруктураРезультата = ПолучитьСтруктуруЗаписиEPC();
	СтруктураРезультата.EPC = EPC;
	СтруктураРезультата.EPC_BIN = БитовыйМассив; 
	
	// Получаем заголовок метки.
	Заголовок = Сред(БитовыйМассив, 1, 8);
	
	Если Заголовок = "00110000" Тогда // Распознан заголовок SGTIN-96.
		
		Формат = "sgtin-96";
		// Для SGTIN-96 длинная серийного номера 38 bit.
		СерийныйНомер = Сред(БитовыйМассив, 59); 
		// Серийный номер состоит из десятичных цифр. Максимальное значение 274,877,906,943
		СерийныйНомер = ДобавитьЛидирующиеНули(Формат(ПреобразоватьБинарнуюСтрокуВЧисло(СерийныйНомер), "ЧГ=0"), 12); 
		
	ИначеЕсли Заголовок = "00110110" Тогда // Распознан заголовок SGTIN-198.
		
		Формат = "sgtin-198";
		// Для SGTIN-198 длинная серийного номера 140 bit.
		СерийныйНомерВрем = Сред(БитовыйМассив, 59); 
		// Серийный номер состоит из 7 битных символов. Максимально 20 символов.
		СерийныйНомер = "";
		Пока СтрДлина(СерийныйНомерВрем) > 0 Цикл
			ТекСимвол  = Лев(СерийныйНомерВрем, 7);
			КодСимвола = ПреобразоватьБинарнуюСтрокуВЧисло(ТекСимвол);
			Если КодСимвола > 0 Тогда
				СерийныйНомер = СерийныйНомер + Символ(КодСимвола);
			КонецЕсли;
			СерийныйНомерВрем = Сред(СерийныйНомерВрем, 8);
		КонецЦикла;
		
	Иначе
		Возврат СтруктураРезультата; // Не распознан формат данных EPC.
	КонецЕсли;
	
	СтруктураРезультата.СерийныйНомер = СерийныйНомер;
	СтруктураРезультата.Формат        = Формат;
	
	Фильтр      = ПреобразоватьБинарнуюСтрокуВЧисло(Сред(БитовыйМассив, 9, 3));
	Разделитель = ПреобразоватьБинарнуюСтрокуВЧисло(Сред(БитовыйМассив, 12, 3));
	
	// Определяем разделить префикса компании.
	Если Разделитель = 1 Тогда
		РазрядовКомпании = 37;
		РазрядовЗнаков   = 11;
	ИначеЕсли Разделитель = 2 Тогда
		РазрядовКомпании = 34;
		РазрядовЗнаков   = 10;
	ИначеЕсли Разделитель = 3 Тогда
		РазрядовКомпании = 30;
		РазрядовЗнаков   = 9;
	ИначеЕсли Разделитель = 4 Тогда
		РазрядовКомпании = 27;
		РазрядовЗнаков   = 8;
	ИначеЕсли Разделитель = 5 Тогда
		РазрядовКомпании = 24;
		РазрядовЗнаков   = 7;
	ИначеЕсли Разделитель = 6 Тогда
		РазрядовКомпании = 20;
		РазрядовЗнаков   = 6;
	Иначе
		РазрядовКомпании = 40;
		РазрядовЗнаков   = 12;
	КонецЕсли;
	
	ПрефиксКомпании = Сред(БитовыйМассив, 15, РазрядовКомпании);
	ГруппаТовара    = Сред(БитовыйМассив, 15 + РазрядовКомпании, 44 - РазрядовКомпании);
	
	ПрефиксКомпании = ДобавитьЛидирующиеНули(Формат(ПреобразоватьБинарнуюСтрокуВЧисло(ПрефиксКомпании), "ЧГ=0"), РазрядовЗнаков); 
	ГруппаТовара    = ДобавитьЛидирующиеНули(Формат(ПреобразоватьБинарнуюСтрокуВЧисло(ГруппаТовара), "ЧГ=0"), 13 - РазрядовЗнаков);
	
	URI = "urn:epc:tag:" + Формат + ":" + Фильтр + "." + ПрефиксКомпании + "." + ГруппаТовара + "." + СерийныйНомер; 
	
	GTIN = Лев(ГруппаТовара, 1) + ПрефиксКомпании + Прав(ГруппаТовара, СтрДлина(ГруппаТовара) - 1);;
	
	Если СтрДлина(GTIN) = 13 Тогда
		GTIN = GTIN + РассчитатьКонтрольныйСимволGTIN14(GTIN) 
	КонецЕсли;
	
	СтруктураРезультата.ПрефиксКомпании = ПрефиксКомпании; 
	СтруктураРезультата.GTIN = GTIN;
	СтруктураРезультата.URI  = URI;
	
	Возврат СтруктураРезультата;        
	
КонецФункции

// Функция определяет, содержит ли EPC значащую информацию (GTIN или СерийныйНомер) по формату SGTIN.
//
// Параметры:
//  EPC - Строка содержащая значение банка EPC в HEX виде.
// 
// Возвращаемое значение:
//   - Булево  
//
Функция ПустойEPC(EPC) Экспорт
	
	БитовыйМассив = ПреобразоватьHEXВБинарнуюСтроку(EPC);
	СерийныйНомер = Прав(БитовыйМассив, 38);
	GTIN = Сред(БитовыйМассив, 15, 44);
	
	СерийныйНомер = ПреобразоватьБинарнуюСтрокуВЧисло(СерийныйНомер);
	GTIN = ПреобразоватьБинарнуюСтрокуВЧисло(GTIN);
	
	Заполнен = (СерийныйНомер > 0) Или (GTIN > 0);                                  
	Возврат Не Заполнен; 
	
КонецФункции

// Сформировать значение EPC в формате SGTIN-96 для GTIN и серийного номера.
//  GTIN допускает в формате GTIN-8, GTIN-12, GTIN-13, GTIN-14.
//
// Параметры:
//  GTIN          - GTIN товарной номенклатуры. Текстовая строка с GTIN(c контрольным символом).
//  СерийныйНомер - Серийный номер номенклатуры.
//  Фильтр        - 
// 
// Возвращаемое значение:
//   - Строка HEX с сформированным EPC для записи на метку RFID.
//
Функция СформироватьДанныеSGTIN96(Знач GTIN, Знач СерийныйНомер, Знач Фильтр = 3) Экспорт
	
	ВремGTIN = ДобавитьЛидирующиеНули(GTIN, 14);
	ВремGTIN = Лев(ВремGTIN, 13); // Отбрасываем контрольный символ.
	
	Если СтрДлина(GTIN) > 13 И Лев(GTIN, 1) <> "0" Тогда
		ЗнаковКомпании = 9;
		Индикатор = Лев(ВремGTIN, 1);
		Компания = Сред(ВремGTIN, 2, ЗнаковКомпании);
		ГруппаТоваров = Индикатор + Прав(ВремGTIN, 3);
	Иначе
		ЗнаковКомпании = 7;
		Компания = Лев(ВремGTIN, ЗнаковКомпании + 1);
		ГруппаТоваров = Сред(ВремGTIN, ЗнаковКомпании + 2);
	КонецЕсли;
	
	Если ЗнаковКомпании = 7 Тогда
		РазрядовКомпании = 24;
		Разделитель      = 5;
	ИначеЕсли ЗнаковКомпании = 9 Тогда
		РазрядовКомпании = 30;
		Разделитель = 3;
	Иначе
		Разделитель      = 3;
		РазрядовКомпании = 30;
	КонецЕсли;
	
	СерийныйНомер = ?(ПустаяСтрока(СерийныйНомер), "0", СерийныйНомер);
	EPC = "00110000";  // Определяем заголовок SGTIN-96.
	EPC = EPC + ДобавитьЛидирующиеНули(ПреобразоватьЧислоВБинарнуюСтроку(Фильтр), 3);      // Фильтр.
	EPC = EPC + ДобавитьЛидирующиеНули(ПреобразоватьЧислоВБинарнуюСтроку(Разделитель), 3); // Разделитель
	EPC = EPC + ДобавитьЛидирующиеНули(ПреобразоватьЧислоВБинарнуюСтроку(Число(Компания)), РазрядовКомпании);
	EPC = EPC + ДобавитьЛидирующиеНули(ПреобразоватьЧислоВБинарнуюСтроку(Число(ГруппаТоваров)), 44 - РазрядовКомпании);
	EPC = EPC + ДобавитьЛидирующиеНули(ПреобразоватьЧислоВБинарнуюСтроку(Число(СерийныйНомер)), 38);
	
	Результат = ПреобразоватьБинарнуюСтрокуВHEX(EPC);
	Возврат Результат;

КонецФункции

// Сформировать серийный номер по правилам производителей чипов.
//
Функция ПолучитьСерийныйНомерПоTID(Знач TID, Знач EPC = Неопределено) Экспорт
	
	ОписаниеОшибки = НСтр("ru='Ошибка генерации серийного номера по TID.'");
	РезультатВыполнения = Новый Структура("Результат, ОписаниеОшибки, СерийныйНомер", Ложь, ОписаниеОшибки);
	
	ПризнакG2 = Лев(TID, 2);
	Если ПризнакG2 <> "E2" Тогда // Фиксированное значение "E2" признак того что тип соответствует EPC Class1Gen2. 
		РезультатВыполнения.ОписаниеОшибки = НСтр("ru='Указанный TID не соответствует типу EPC Class1Gen2.'");
		Возврат РезультатВыполнения;
	КонецЕсли;
	
	// Преобразовываем HEX строку значение банка TID в бинарную строку.
	БитовыйМассив = ПреобразоватьHEXВБинарнуюСтроку(TID);
	// Получаем префикс производителя.
	Производитель = Сред(TID, 3, 3);
	
	Если Производитель = "001" Или Производитель = "801" Тогда // Чипы Impinj
		
		СерияЧипа = Сред(БитовыйМассив, 84, 2); // Серия чипа 00
		Если СерияЧипа = "00" Тогда
			СерийныйНомер = "000" + 
						Сред(БитовыйМассив, 86, 8) + 
						Сред(БитовыйМассив, 66, 15) +
						Сред(БитовыйМассив, 94, 3) +
						Сред(БитовыйМассив, 65, 1) +
						Сред(БитовыйМассив, 55, 4) +
						Сред(БитовыйМассив, 61, 4);
		Иначе // Серия чипа 01,10,11
			СерийныйНомер = 
						Сред(БитовыйМассив, 86, 11) + 
						Сред(БитовыйМассив, 65, 16) +
						Сред(БитовыйМассив, 52, 2) +
						Сред(БитовыйМассив, 57, 1) +
						Сред(БитовыйМассив, 55, 4) +
						Сред(БитовыйМассив, 61, 4);
					КонецЕсли;
					
	ИначеЕсли Производитель = "006" Или Производитель = "806" Тогда // Чипы NXP Semiconductors 
		
		СерияЧипа = Сред(БитовыйМассив, 21, 11); // Серия чипа 
		СерияЧипа = ПреобразоватьБинарнуюСтрокуВHEX(СерияЧипа);
		Если СерияЧипа = "806" Или СерияЧипа = "807" Тогда // G2iL или G2iL+
			СерийныйНомер = "111" +
				Сред(БитовыйМассив, 24, 3) + 
				Сред(БитовыйМассив, 33, 32);
		Иначе
			СерийныйНомер = Сред(БитовыйМассив, 59, 38);
			
		КонецЕсли;
		
	ИначеЕсли Производитель = "003" Или Производитель = "803" Тогда // Чипы Alien Technology  
		
		Если ПустаяСтрока(EPC) Тогда
			РезультатВыполнения.ОписаниеОшибки = НСтр("ru='Для генерация серийного номера для чипов ""Alien Technology"" необходимо указание EPC .'");
			Возврат РезультатВыполнения;
		КонецЕсли;
		
		СтруктураEPC = ДекодированиеДанныхSGTIN(EPC);
		Если Не СтруктураEPC.Результат Тогда
			РезультатВыполнения.ОписаниеОшибки = НСтр("ru='Ошибка декодирования EPC для чипов ""Alien Technology"".'");
			Возврат РезультатВыполнения;
		КонецЕсли;
		
		РезультатВыполнения.СерийныйНомер = СтруктураEPC.СерийныйНомер; 
		
	Иначе
		
		РезультатВыполнения.ОписаниеОшибки = НСтр("ru='Генерация серийного номера для чипа производителя указанного в TID не поддерживается.'");
		Возврат РезультатВыполнения;
		
	КонецЕсли;
	
	РезультатВыполнения.Результат = Истина;
	РезультатВыполнения.СерийныйНомер = ПреобразоватьБинарнуюСтрокуВЧисло(СерийныйНомер);
		
	Возврат РезультатВыполнения;
	
КонецФункции

// Преобразовывает HEX строку в строку символов.
//
// Параметры:
//  СтрокаHEX - Строка HEX содержащая символы.  
// 
// Возвращаемое значение:
//   - Тестовая строка
//
Функция ПреобразоватьHEXВСтроку(Знач СтрокаHEX) Экспорт
	
	Результат = "";
	ВремСтрока = СтрокаHEX;
	КодСимвола = 0;
	
	Пока СтрДлина(ВремСтрока) > 0 Цикл
		ТекСимвол  = Лев(ВремСтрока, 2);
		ТекСимвол  = ПреобразоватьHEXВБинарнуюСтроку(ТекСимвол);
		КодСимвола = ПреобразоватьБинарнуюСтрокуВЧисло(ТекСимвол);
		Если КодСимвола > 31 Тогда
			Результат = Результат + Символ(КодСимвола);
		КонецЕсли;
		ВремСтрока = Сред(ВремСтрока, 3);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Преобразовывает строку символов в HEX строку.
//
// Параметры:
//   Строка - Тестовая строка
// 
// Возвращаемое значение:
//   - СтрокаHEX - Строка HEX содержащая символы.  
//
Функция ПреобразоватьСтрокуВHEX(Знач Строка) Экспорт
	
	Результат = "";
	ИндексСимвола = 1;
	
	Пока ИндексСимвола <= СтрДлина(Строка) Цикл
		ТекКод = КодСимвола(Строка, ИндексСимвола);
		ТекСимвол = ДобавитьЛидирующиеНули(ПреобразоватьЧислоВБинарнуюСтроку(ТекКод), 8);
		Результат = Результат + ПреобразоватьБинарнуюСтрокуВHEX(ТекСимвол);
		ИндексСимвола = ИндексСимвола + 1;
	КонецЦикла;
	
	Результат = ДобавитьЛидирующиеНули(Результат, 8);
	Возврат Результат;
	
КонецФункции

// Функция - Преобразовать HEX в бинарную строку
//
// Параметры:
//  СтрокаHEX - Строка HEX содержащая символы.  
// 
// Возвращаемое значение:
//   - Текстовая строка в бинарном представлении (Пример "000010101"). 
//
Функция ПреобразоватьHEXВБинарнуюСтроку(Знач СтрокаHEX) Экспорт
	
	Результат = "";
	
	Для ИндексСимвола = 1 По СтрДлина(СтрокаHEX) Цикл 
		ТекСимвол = Сред(СтрокаHEX, ИндексСимвола, 1);
		Если ТекСимвол = "0" Тогда 
			Результат = Результат + "0000"
		ИначеЕсли ТекСимвол = "1" Тогда 
			Результат = Результат + "0001"
		ИначеЕсли ТекСимвол = "2" Тогда 
			Результат = Результат + "0010"
		ИначеЕсли ТекСимвол = "3" Тогда 
			Результат = Результат + "0011"
		ИначеЕсли ТекСимвол = "4" Тогда 
			Результат = Результат + "0100"
		ИначеЕсли ТекСимвол = "5" Тогда 
			Результат = Результат + "0101"
		ИначеЕсли ТекСимвол = "6" Тогда 
			Результат = Результат + "0110"
		ИначеЕсли ТекСимвол = "7" Тогда 
			Результат = Результат + "0111"
		ИначеЕсли ТекСимвол = "8" Тогда 
			Результат = Результат + "1000"
		ИначеЕсли ТекСимвол = "9" Тогда 
			Результат = Результат + "1001"
		ИначеЕсли ТекСимвол = "A" Тогда 
			Результат = Результат + "1010"
		ИначеЕсли ТекСимвол = "B" Тогда 
			Результат = Результат + "1011"
		ИначеЕсли ТекСимвол = "C" Тогда 
			Результат = Результат + "1100"
		ИначеЕсли ТекСимвол = "D" Тогда 
			Результат = Результат + "1101"
		ИначеЕсли ТекСимвол = "E" Тогда 
			Результат = Результат + "1110"
		ИначеЕсли ТекСимвол = "F" Тогда 
			Результат = Результат + "1111"
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Функция - Преобразовать бинарную строку ВHEX
//
// Параметры:
//  БинарнаяСтрока- Текстовая строка в бинарном представлении (Пример "000010101").
// 
// Возвращаемое значение:
//   - Строка HEX содержащая символы.  
//
Функция ПреобразоватьБинарнуюСтрокуВHEX(Знач БинарнаяСтрока) Экспорт
	
	Результат = "";
	ВремСтрока = БинарнаяСтрока;
	
	Пока СтрДлина(ВремСтрока) > 0 Цикл
		ТекСимвол = Лев(ВремСтрока, 4);
		Если ТекСимвол = "0000" Тогда 
			Результат = Результат + "0";
		ИначеЕсли ТекСимвол = "0001" Тогда 
			Результат = Результат + "1";
		ИначеЕсли ТекСимвол = "0010" Тогда 
			Результат = Результат + "2";
		ИначеЕсли ТекСимвол = "0011" Тогда 
			Результат = Результат + "3";
		ИначеЕсли ТекСимвол = "0100" Тогда 
			Результат = Результат + "4";
		ИначеЕсли ТекСимвол = "0101" Тогда 
			Результат = Результат + "5";
		ИначеЕсли ТекСимвол = "0110" Тогда 
			Результат = Результат + "6";
		ИначеЕсли ТекСимвол = "0111" Тогда 
			Результат = Результат + "7";
		ИначеЕсли ТекСимвол = "1000" Тогда 
			Результат = Результат + "8";
		ИначеЕсли ТекСимвол = "1001" Тогда 
			Результат = Результат + "9";
		ИначеЕсли ТекСимвол = "1010" Тогда 
			Результат = Результат + "A";
		ИначеЕсли ТекСимвол = "1011" Тогда 
			Результат = Результат + "B";
		ИначеЕсли ТекСимвол = "1100" Тогда 
			Результат = Результат + "C";
		ИначеЕсли ТекСимвол = "1101" Тогда 
			Результат = Результат + "D";
		ИначеЕсли ТекСимвол = "1110" Тогда 
			Результат = Результат + "E";
		ИначеЕсли ТекСимвол = "1111" Тогда 
			Результат = Результат + "F";
		КонецЕсли;
		ВремСтрока = Сред(ВремСтрока, 5);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Функция - Преобразовать бинарную строку в десятичное число
//
// Параметры:
//  БинарнаяСтрока - Текстовая строка в бинарном представлении (Пример "000010101"). 
// 
// Возвращаемое значение:
//   - Десятичное число. 
//
Функция ПреобразоватьБинарнуюСтрокуВЧисло(Знач БинарнаяСтрока) Экспорт
	
	Результат = 0;
	ТекущийИндекс = СтрДлина(БинарнаяСтрока) - 1;
	
	Для ИндексСимвол = 1 По СтрДлина(БинарнаяСтрока) Цикл
		ТекСимвол = Сред(БинарнаяСтрока, ИндексСимвол, 1);
		Если ТекСимвол = "1" Тогда
			Результат = Результат + Pow(2, ТекущийИндекс); 
		КонецЕсли;
		ТекущийИндекс = ТекущийИндекс - 1;
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Функция - Преобразовать десятичное число в бинарную строку
//
// Параметры:
//  Число - Десятичное число которое будет преобразовано в бинарный вид. 
// 
// Возвращаемое значение:
//   - Текстовая строка в бинарном представлении (Пример "000010101").
//
Функция ПреобразоватьЧислоВБинарнуюСтроку(Знач Число) Экспорт 
	
	Результат = "";
	
	Пока Число > 0 Цикл
		Остаток = Число % 2;
		Число = Цел(Число / 2);
		Результат = Строка(Остаток) + Результат;
	КонецЦикла;
	
	Результат =?(ПустаяСтрока(Результат), "0", Результат); 
	Возврат Результат;
	
КонецФункции

// Получить код типа расчета денежными средствами.
// 
Функция ПолучитьКодТипаРасчетаДенежнымиСредствами(ТипРасчета) Экспорт
	
	Если ТипРасчета = ПредопределенноеЗначение("Перечисление.ТипыРасчетаДенежнымиСредствами.ПриходДенежныхСредств") Тогда
		ПризнакРасчетаКод = 1 
	ИначеЕсли ТипРасчета = ПредопределенноеЗначение("Перечисление.ТипыРасчетаДенежнымиСредствами.ВозвратДенежныхСредств") Тогда
		ПризнакРасчетаКод = 2 
	ИначеЕсли ТипРасчета = ПредопределенноеЗначение("Перечисление.ТипыРасчетаДенежнымиСредствами.РасходДенежныхСредств") Тогда
		ПризнакРасчетаКод = 3
	Иначе
		ПризнакРасчетаКод = 4
	КонецЕсли;
	
	Возврат ПризнакРасчетаКод;
	
КонецФункции

// Заполняет структуру общих параметров фискального накопителя.
//
Функция ПараметрыФискальногоНакопителяОбщие() Экспорт
	
	Параметры = Новый Структура();
	Параметры.Вставить("РегистрационныйНомерККТ");
	Параметры.Вставить("ОрганизацияНазвание");
	Параметры.Вставить("ОрганизацияИНН");
	Параметры.Вставить("АдресУстановкиККТ");
	Параметры.Вставить("КодыСистемыНалогообложения");
	Параметры.Вставить("ПризнакАвтономногоРежима"      , Ложь);
	Параметры.Вставить("ПризнакАвтоматическогоРежима"  , Ложь);
	Параметры.Вставить("НомерАвтоматаДляАвтоматическогоРежима");
	Параметры.Вставить("ПризнакШифрованиеДанных"       , Ложь);
	Параметры.Вставить("ПризнакРасчетовЗаУслуги"       , Ложь);
	Параметры.Вставить("ПризнакФормированияТолькоБСО"  , Ложь);
	Параметры.Вставить("ПризнакРасчетовТолькоВИнтернет", Ложь);
	Параметры.Вставить("ОрганизацияОФДИНН");
	Параметры.Вставить("ОрганизацияОФДНазвание");
	Возврат Параметры; 
	
КонецФункции

// Заполняет структуру параметров Фискализации ФН.
//
Функция ПараметрыОперацииФискализацииНакопителя() Экспорт
	
	Параметры = ПараметрыФискальногоНакопителяОбщие();
	Параметры.Вставить("КодПричиныПеререгистрации"); 
	Параметры.Вставить("ТипОперации", 1);
	Возврат Параметры; 
	
КонецФункции

// Заполняет структуру параметров регистрации ККТ.
//
Функция ПараметрыРегистрацииККТ() Экспорт
	
	Параметры = ПараметрыФискальногоНакопителяОбщие();
	Параметры.Вставить("ЗаводскойНомерККТ");
	Параметры.Вставить("ПризнакФискализации");
	Параметры.Вставить("ЗаводскойНомерФН");
	Параметры.Вставить("НомерДокументаФискализации");
	Параметры.Вставить("ДатаВремяФискализации");
	Параметры.Вставить("ВерсияФФДККТ");
	Параметры.Вставить("ВерсияФФДФН");

	Возврат Параметры; 
	
КонецФункции

// Заполняет структуру параметров операции фискализации чека.
//
Функция ПараметрыОперацииФискализацииЧека() Экспорт;
	
	ПараметрыЧека = Новый Структура();
	// Общие реквизиты для всех типов оборудования.
	ПараметрыЧека.Вставить("ДокументОснование"  , Неопределено);
	ПараметрыЧека.Вставить("ТипРасчета"         , ПредопределенноеЗначение("Перечисление.ТипыРасчетаДенежнымиСредствами.ПриходДенежныхСредств"));
	ПараметрыЧека.Вставить("Кассир"             , Неопределено); // Должность и фамилия лица, осуществившего расчет с покупателем (клиентом), оформившего кассовый чек.
	ПараметрыЧека.Вставить("КассирИНН"          , Неопределено); // Идентификационный номер налогоплательщика кассира, при наличии.
	ПараметрыЧека.Вставить("Электронно"         , Ложь); // Чек будет предоставлен в элетронной форме, без печати.
	
	ПараметрыЧека.Вставить("Отправляет1СSMS"   , Ложь); // SMS отправляет средствами 1C.
	ПараметрыЧека.Вставить("Отправляет1СEmail" , Ложь); // Email отправляет средствами 1C. 
	
	ПараметрыЧека.Вставить("ОрганизацияНазвание" , Неопределено);
	ПараметрыЧека.Вставить("ОрганизацияИНН"      , Неопределено); // ИНН организации (Для чека ЕНВД)
	ПараметрыЧека.Вставить("ОрганизацияКПП"      , Неопределено); // Название организации (Для чека ЕНВД)
	ПараметрыЧека.Вставить("АдресМагазина"       , Неопределено); // Адрес магазина (Для чека ЕНВД)
	ПараметрыЧека.Вставить("НаименованиеМагазина", Неопределено); // Наименование магазина
	// Параметры необходимые для ФР
	ПараметрыЧека.Вставить("СерийныйНомер"      , Неопределено); // Заводской номер ККМ
	// Параметры необходимые для чека ЕНВД на принтере чеков
	ПараметрыЧека.Вставить("НомерКассы"         , Неопределено);
	ПараметрыЧека.Вставить("НомерЧека"          , Неопределено);
	ПараметрыЧека.Вставить("НомерСмены"         , Неопределено);
	ПараметрыЧека.Вставить("ДатаВремя"          , ТекущаяДата());
	ПараметрыЧека.Вставить("ТекстШапки"         , НСтр("ru='ДОБРО ПОЖАЛОВАТЬ!'"));
	ПараметрыЧека.Вставить("ТекстПодвала"       , НСтр("ru='СПАСИБО ЗА ПОКУПКУ!'"));
	// Параметры для ККТ по ФЗ-54
	ПараметрыЧека.Вставить("КодСистемыНалогообложения", Неопределено);  
	ПараметрыЧека.Вставить("ОтправительEmail"         , Неопределено);
	ПараметрыЧека.Вставить("ПокупательEmail"          , Неопределено);
	ПараметрыЧека.Вставить("ПокупательНомер"          , Неопределено);
	ПараметрыЧека.Вставить("ВознагражденияАгента"     , Неопределено); // AgentCompensation
	ПараметрыЧека.Вставить("ТелефонПлатежногоАгента"  , Неопределено); // AgentPhone 
	ПараметрыЧека.Вставить("ТелефонОператораПоПриемуПлатежей", Неопределено); // ReceivePaymentsOperatorPhone
	ПараметрыЧека.Вставить("ТелефонОператораПеревода"        , Неопределено); // MoneyTransferOperatorPhone
	ПараметрыЧека.Вставить("ТелефонПоставщика"               , Неопределено);
	ПараметрыЧека.Вставить("АдресОператораПеревода"          , Неопределено); // MoneyTransferOperatorAddress
	ПараметрыЧека.Вставить("ИННОператораПеревода"            , Неопределено); // MoneyTransferOperatorVATIN
	ПараметрыЧека.Вставить("НаименованиеОператораПеревода"   , Неопределено); // MoneyTransferOperatorName
	ПараметрыЧека.Вставить("ОперацияПлатежногоАгента"        , Неопределено);
	ПараметрыЧека.Вставить("ТелефонБанковскогоАгента"        , Неопределено); // BankAgentPhone
	ПараметрыЧека.Вставить("ТелефонБанковскогоСубагента"     , Неопределено); // BankSubagentPhone
	ПараметрыЧека.Вставить("ОперацияБанковскогоАгента"       , Неопределено); // BankAgentOperation
	ПараметрыЧека.Вставить("ОперацияБанковскогоСубагента"    , Неопределено); // BankSubagentOperation
	ПараметрыЧека.Вставить("ВознагражденияБанковскогоАгента" , Неопределено); // BankAgentCompensation
	// Позиции чека для фискализации
	ПараметрыЧека.Вставить("ПозицииЧека"  , Новый Массив()); // Массив элементов "Структура"
	ПараметрыЧека.Вставить("ТаблицаОплат" , Новый Массив()); // Массив элементов "Структура"
	
	Возврат ПараметрыЧека; 
	
КонецФункции

// Заполняет структуру параметров фискальной строки для фискализации чека.
//
Функция ПараметрыФискальнойСтрокиЧека() Экспорт;
	
	ПараметрыСтроки = Новый Структура();
	ПараметрыСтроки.Вставить("ФискальнаяСтрока"); 
	// Обязательные поля
	ПараметрыСтроки.Вставить("Наименование");    // Наимновнование предмета расчета
	ПараметрыСтроки.Вставить("Количество"  , 0); // Количество предмета расчета 
	ПараметрыСтроки.Вставить("Цена"        , 0); // Цена без учета скидок и наценок
	ПараметрыСтроки.Вставить("Сумма"       , 0); // Cтоимость предмета расчета с учетом скидок и наценок
	ПараметрыСтроки.Вставить("НомерСекции" , 0); // Номер cекции ФР (для совместимости)
	ПараметрыСтроки.Вставить("СтавкаНДС"   , 0); // Cтавка НДС в %
	ПараметрыСтроки.Вставить("Штрихкод");        // Штрихкод
	// Дополнительные реквизиты начиная с ФФД 1.1
	ПараметрыСтроки.Вставить("КодПризнакаСпособаРасчета");  // Код признака способа расчета (Таблица 25 документа ФФД)
	ПараметрыСтроки.Вставить("КодПризнакаПредметаРасчета"); // Код признака предмета расчета   (Таблица 25 документа ФФД)
	ПараметрыСтроки.Вставить("ЕдиницаИзмеренияПредметаРасчета"); // Код признака предмета расчета 
	ПараметрыСтроки.Вставить("КодТоварнойНоменклатуры");    // Код товарной номенклатуры
	
	Возврат ПараметрыСтроки; 
	
КонецФункции

// Заполняет структуру параметров текстовой строки для фискализации чека.
//
Функция ПараметрыТекстовойСтрокиЧека(Текст = Неопределено) Экспорт;
	
	ПараметрыСтроки = Новый Структура();
	ПараметрыСтроки.Вставить("ТекстоваяСтрока"); 
	ПараметрыСтроки.Вставить("Текст", Текст);   
	Возврат ПараметрыСтроки; 
	
КонецФункции

// Заполняет структуру параметров штрихкода в строке для фискализации чека.
//
Функция ПараметрыШтрихкодВСтрокеЧека(ТипШтрихкода = Неопределено, ШтрихКод = Неопределено) Экспорт;
	
	ПараметрыСтроки = Новый Структура();
	ПараметрыСтроки.Вставить("ШтрихКод");
	ПараметрыСтроки.Вставить("ТипШтрихкода", ТипШтрихкода);
	ПараметрыСтроки.Вставить("ШтрихКод"    , ШтрихКод);
	Возврат ПараметрыСтроки; 
	
КонецФункции

// Заполняет структуру параметров выполнения эквайринговой операции.
//
Функция ПараметрыОперацииЧекаКоррекции() Экспорт;
	
	ПараметрыЧека = Новый Структура();
	
	ПараметрыЧека.Вставить("ТипРасчета" , ПредопределенноеЗначение("Перечисление.ТипыРасчетаДенежнымиСредствами.РасходДенежныхСредств"));
	ПараметрыЧека.Вставить("Кассир"     , Неопределено); // Должность и фамилия лица, осуществившего расчет с покупателем (клиентом), оформившего кассовый чек.
	ПараметрыЧека.Вставить("КассирИНН"  , Неопределено); // Идентификационный номер налогоплательщика кассира, при наличии.
	ПараметрыЧека.Вставить("ТипОплаты"  , 0);            // Наличные
	ПараметрыЧека.Вставить("Сумма"      , 0);
	ПараметрыЧека.Вставить("КодСистемыНалогообложения"); // Код системы налогооблажения 
	ПараметрыЧека.Вставить("НаименованиеОснования");     // Наименование документа основания для коррекции
	ПараметрыЧека.Вставить("ДатаДокументаОснования");    // Дата документа основания для коррекции
	ПараметрыЧека.Вставить("номерДокументаОснования");   // Номер документа основания для коррекции
	
	Возврат ПараметрыЧека; 
	
КонецФункции

// Заполняет структуру параметров выполнения эквайринговой операции.
//
Функция ПараметрыОперацииАннулированияЧека() Экспорт;
	
	ПараметрыЧека = Новый Структура();
	
	ПараметрыЧека.Вставить("ТипРасчета" , ПредопределенноеЗначение("Перечисление.ТипыРасчетаДенежнымиСредствами.ПриходДенежныхСредств"));
	ПараметрыЧека.Вставить("Кассир"     , Неопределено); // Должность и фамилия лица, осуществившего расчет с покупателем (клиентом), оформившего кассовый чек.
	ПараметрыЧека.Вставить("Фискальный" , Истина); 
	
	Возврат ПараметрыЧека; 
	
КонецФункции

// Получить наименование системы налогообложения по коду.
//
Функция ПолучитьНаименованиеСистемыНалогообложения(КодСистемыНалогообложения) Экспорт;
	
	СистемыНалогообложения = Новый Соответствие();
	СистемыНалогообложения.Вставить(0, НСтр("ru='Общая'"));
	СистемыНалогообложения.Вставить(1, НСтр("ru='Упрощенная Доход'"));
	СистемыНалогообложения.Вставить(2, НСтр("ru='Упрощенная Доход минус Расход'"));
	СистемыНалогообложения.Вставить(3, НСтр("ru='Единый налог на вмененный доход'"));
	СистемыНалогообложения.Вставить(4, НСтр("ru='Единый сельскохозяйственный налог'"));
	СистемыНалогообложения.Вставить(5, НСтр("ru='Патентная система налогообложения'"));
	Возврат СистемыНалогообложения.Получить(КодСистемыНалогообложения);
	
КонецФункции

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

Функция ДобавитьЛидирующиеНули(Знач Строка, Знач ДлиннаСтроки) 
	
	ТекстПолный = Строка;
	Пока СтрДлина(ТекстПолный) < ДлиннаСтроки Цикл
		ТекстПолный = "0" + ТекстПолный;
	КонецЦикла;
	          
	Возврат ТекстПолный;
	
КонецФункции

Функция ОпределитьКоличествоПакетов(РазмерПакета, КоличествоЭлементов)
	
	Если РазмерПакета = 0 Тогда
		КоличествоПакетов = 1;
	Иначе
		// Определяем количество полных пакетов.
		КоличествоПолныхПакетов = Цел(КоличествоЭлементов/РазмерПакета);
		//	Если количество элементов на пакет больше чем определенное количество пакетов, добавляем один неполный пакет.
		КоличествоПакетов = КоличествоПолныхПакетов + ?((КоличествоЭлементов/РазмерПакета)-КоличествоПолныхПакетов>0, 1, 0);
	КонецЕсли;
	
	Возврат КоличествоПакетов;
	
КонецФункции

// Определяет необходимость выполнения серверного собития ПослеВыполненияКомандыФискальнымУстройством
Функция ТребуетсяВызовСобытияПослеВыполненияКомандыФискальнымУстройством(Контекст) Экспорт
	
	Если не КомандыРаботыСоСменами().Найти(Контекст.ВыполняемаяКоманда) = Неопределено Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

// Возвращает массив команд работы с кассовой сменой
Функция КомандыРаботыСоСменами()
	
	МассивРезультат = Новый Массив();
	
	//МассивРезультат.Добавить("ReportCurrentStatusOfSettlements");
	МассивРезультат.Добавить("OpenShift");
	МассивРезультат.Добавить("CloseShift");
	
	Возврат МассивРезультат;
	
КонецФункции

// Заполняет структуру параметров состояния ККТ.
//
Функция ПараметрыСостоянияККТ() Экспорт;
	
	Параметры = Новый Структура();
	Параметры.Вставить("КоличествоНепереданныхФД"   , Неопределено); 
	Параметры.Вставить("НомерПервогоНепереданногоФД", Неопределено); 
	Параметры.Вставить("ДатаПервогоНепереданногоФД ", Неопределено); 
	
	Возврат Параметры; 
	
КонецФункции

// Заполняет структуру параметров нормализуемых фискальных данных
//
Функция ПараметрыНормализуемыхФискальныхДанных() Экспорт
	
	СтруктураРезультат = ПараметрыСостоянияККТ();
	
	СтруктураРезультат.Вставить("ДатаСменыККТ");
	СтруктураРезультат.Вставить("НомерСменыККТ");
	СтруктураРезультат.Вставить("КоличествоЧеков");
	СтруктураРезультат.Вставить("КоличествоФД");
	СтруктураРезультат.Вставить("ПревышеноВремяОжиданияОтветаОФД");
	СтруктураРезультат.Вставить("НеобходимаСтрочнаяЗаменаФН");
	СтруктураРезультат.Вставить("ПамятьФНПереполнена");
	СтруктураРезультат.Вставить("РесурсФНИсчерпан");
	
	Возврат СтруктураРезультат;
	
КонецФункции

Функция ТребуетсяЗакрытиеСмены(СтатусСмены) Экспорт
	
	Если СтатусСмены = 0 или СтатусСмены = 1 Тогда // неопределено или закрыта
		Возврат Ложь;
	ИначеЕсли СтатусСмены = 2 или СтатусСмены = 3 Тогда // открыта или истекла
		Возврат Истина;
	Иначе
		ТекстОшибки = НСтр("ru = 'Неизвестный статус смены'");
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
КонецФункции

#КонецОбласти