var dso_handle_ptr = (typedef void*)(_dyld_get_image_header(0));
var _os_log_default = (typedef NSObject*)(dlsym(RTLD_DEFAULT, "_os_log_default"));
var _os_log_disabled = (typedef NSObject*)(dlsym(RTLD_DEFAULT, "_os_log_disabled"));
var os_log_create = (typedef NSObject*(const char*, const char*))(dlsym(RTLD_DEFAULT, "os_log_create"));
var _os_log_internal = (typedef void(void*, NSObject*, uint8_t, const char*))(dlsym(RTLD_DEFAULT, "_os_log_internal"));

module.exports = class OSLog {
    static get default() {
        if (this.$default === undefined) {
            this.$default = new OSLog(_os_log_default);
        }
        return this.$default;
    }

    static get disabled() {
        if (this.$disabled === undefined) {
            this.$disabled = new OSLog(_os_log_disabled);
        }
        return this.$disabled;
    }

    static get cy() {
        if (this.$cy === undefined) {
            this.$cy = new OSLog("com.saurik.cycript", "cycript");
        }
        return this.$cy;
    }

    constructor(subsystem, category) {
        if (typeid(subsystem).toString() == (typedef OS_os_log *).toString()) {
            this.$os_log = subsystem;
        } else {
            this.$os_log = os_log_create(subsystem, category);
        }
    }

    log(message) {
        this.logDefault(message);
    }

    logDefault(message) {
        this.$log(0x00, message);
    }

    logInfo(message) {
        this.$log(0x01, message);
    }

    logDebug(message) {
        this.$log(0x02, message);
    }

    logError(message) {
        this.$log(0x10, message);
    }

    logFault(message) {
        this.$log(0x11, message);
    }

    $log(type, message) {
        if (dso_handle_ptr != null) {
            _os_log_internal(dso_handle_ptr, this.$os_log, type, message);
        }
    }
}